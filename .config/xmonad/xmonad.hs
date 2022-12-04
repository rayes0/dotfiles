-- -*- flycheck-ghc-search-path: \./; -*-
{-# LANGUAGE NoMonomorphismRestriction, FlexibleContexts, MultiWayIf #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures
                -fno-warn-name-shadowing
                -fno-warn-incomplete-patterns #-}
import XMonad
import XMonad.Prelude

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
-- import XMonad.Hooks.DynamicProperty

import XMonad.Layout.VoidBorders
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.BoringWindows
import XMonad.Layout.Renamed
import XMonad.Layout.TrackFloating
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle

import XMonad.Actions.FloatSnap
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Actions.Minimize
import XMonad.Actions.GridSelect
import XMonad.Actions.PerWindowKeys
-- import XMonad.Actions.OnScreen
import XMonad.Actions.WindowGo
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.Prefix
import XMonad.Actions.SpawnOn
import XMonad.Actions.Promote
-- import XMonad.Actions.Submap
import XMonad.Actions.MouseGestures

-- import XMonad.Util.Font
import XMonad.Util.Cursor
import XMonad.Util.WindowProperties hiding ( Property( Not ) )
import XMonad.Util.Paste (sendKey)
import XMonad.Util.WorkspaceCompare

-- import XMonad.Prompt
-- import XMonad.Prompt.XMonad

import qualified XMonad.Actions.FlexibleManipulate as Flex

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import Graphics.X11.ExtraTypes.XF86
import Text.Regex.PCRE ((=~))

main :: IO ()
main = xmonad $ usePrefixArgument "M-u" $ ewmhFullscreen $ ewmh $ withNavigation2DConfig def $ myConfig

myStartup = do setDefaultCursor xC_left_ptr
               spawn "if ! pgrep -x xbanish; then xbanish -i 5; fi"
               spawn "autorandr --change"

myConfig = def { modMask            = mod4Mask
               , borderWidth        = 3
               , focusFollowsMouse  = False
               , clickJustFocuses   = False
               , workspaces         = ["1", "2"]
               , normalBorderColor  = "#dad3d0"
               , focusedBorderColor = "#ba9eba"
               , keys               = myKeys
               , mouseBindings      = myMouseBinds
               , layoutHook         = myLayouts
               , manageHook         = myManaged
               , handleEventHook    = myHandled
               , startupHook        = myStartup }

-- myColorizer' w active = find (\(q, s) -> runQuery q w) colorizerQueries 
  -- mapM checkWindowColour colorizerQueries
  -- where
    -- checkWindowColour e = do match <- (runQuery (fst e) w)
                             -- if match
                               -- then return (snd e)
                               -- else return "#ede6e3"
    -- colorizerQueries = [ (title =? "emacs",  "#6c605a") ]

myGSWindowConfig = (buildDefaultGSConfig colorizer)
                   { gs_cellheight = 50
                   , gs_cellwidth = 370
                   , gs_cellpadding = 10
                   , gs_font = "xft:Noto Sans:pixelsize=15"
                   , gs_navigate = myGSNavigation
                   , gs_rearranger = noRearranger
                   , gs_bordercolor = "#937f74" }
  where
    colorizer w fg = if fg
                     then return ("#fff2a8", "#6c605a")
                     else bgcolor w >>= return
    bgcolor w = do m <- filterM (\(q, _) -> runQuery q w) queries
                   case m of
                     [] -> return ("#dad3d0", "#6c605a")
                     l:_ -> return $ (snd l, "#6c605a")
    -- format: (query, bg)
    -- S: 10, V: 85
    queries = [ (className =? "Emacs", "#d9c3c5")
              , (className =? "Tor Browser", "#d9c3d9")
              , (className =? "librewolf", "#ccd9d5")
              , (className =? "Chromium-browser", "#c3c9d9")
              , (className =? "URxvt", "#d9c8c3")
              , (className =? "Anki", "#c3d9d7")
              , (className =? "mpv", "#d7d9c3")
              , (className =? "Zathura", "#d9d3c3")
              , (className =? "Nyxt", "#c3d9d9") ]

myGSWsConfig = (buildDefaultGSConfig colorizer)
               { gs_cellheight = 40
               , gs_cellwidth = 100
               , gs_cellpadding = 10
               , gs_font = "xft:Noto Sans:pixelsize=15"
               , gs_navigate = myGSNavigation
               , gs_rearranger = noRearranger
               , gs_bordercolor = "#937f74" }
  where
    colorizer s fg = if fg
                     then return ("#fff2a8", "#6c605a")
                     else do t <- withWindowSet (pure . W.currentTag)
                             if s == t
                               then return ("#f0d8f5", "#6c605a")
                               else ifM (isEmpty s) (return ("#f5dad8", "#6c605a")) (return ("#dad3d0", "#6c605a"))
    isEmpty t = do wsl <- gets $ W.workspaces . windowset
                   let mws = find (\ws -> W.tag ws == t) wsl
                   return $ maybe True (isNothing . W.stack) mws

myGSNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
 where navKeyMap = M.fromList [ ((0,xK_Escape), cancel)
                              , ((controlMask,xK_bracketleft), cancel)
                              , ((mod4Mask,xK_w), cancel)
                              , ((controlMask,xK_g), cancel)
                              , ((0,xK_Return), select)
                              , ((controlMask,xK_b) , move (-1,0)  >> myGSNavigation)
                              , ((controlMask,xK_f) , move (1,0)   >> myGSNavigation)
                              , ((controlMask,xK_n) , move (0,1)   >> myGSNavigation)
                              , ((controlMask,xK_p) , move (0,-1)  >> myGSNavigation)
                              , ((0,xK_space) , setPos (0,0) >> myGSNavigation)
                              , ((0,xK_BackSpace), transformSearchString (\s -> if s == "" then "" else init s)
                                                   >> myGSNavigation)
                              , ((controlMask,xK_u), transformSearchString (\_ -> "") >> myGSNavigation) ]
       navDefaultHandler (_,s,_) = do transformSearchString (++ s)
                                      myGSNavigation


-- myWindowMenu = withFocused $ \w -> do
--     tags <- asks (workspaces . config)
--     Rectangle x y wh ht <- getSize w
--     Rectangle sx sy swh sht <- gets $ screenRect . W.screenDetail . W.current . windowset
--     let originFractX = (fi x - fi sx + fi wh / 2) / fi swh
--         originFractY = (fi y - fi sy + fi ht / 2) / fi sht
--         gsConfig = (buildDefaultGSConfig myColorizer) { gs_cellheight = 30
--                                                       , gs_cellwidth = 50
--                                                       , gs_cellpadding = 10
--                                                       , gs_font = "xft:Cascadia Code:pixelsize=14"
--                                                       , gs_navigate = myGSNavigation
--                                                       , gs_rearranger = noRearranger
--                                                       , gs_bordercolor = "#937f74"
--                                                       , gs_originFractX = originFractX
--                                                       , gs_originFractY = originFractY }
--         actions = [ ("^ M", sendMessage $ maximizeRestore w)
--                   , ("× Q", kill)
--                   , ("| m", minimizeWindow w) ]
--                   ++
--                   [ ("→ " ++ tag, windows $ W.shift tag)
--                   | tag <- tags ]
--     runSelectedAction gsConfig actions

-- getSize :: Window -> X Rectangle
-- getSize w = do
--   d  <- asks display
--   wa <- io $ getWindowAttributes d w
--   let x = fi $ wa_x wa
--       y = fi $ wa_y wa
--       wh = fi $ wa_width wa
--       ht = fi $ wa_height wa
--   return (Rectangle x y wh ht)

myKeys (XConfig {XMonad.modMask = mod}) = M.fromList $
  [ ((mod,               xK_Return), spawnP "emacsclient -cqune '(my/setup-eshell-external)' || urxvt")
  , ((mod .|. shiftMask, xK_Return), prefixToggle (spawn "emacsclient -cqunF '((name . \"eshell\") (width . 85) (height . 30))' -e '(my/setup-eshell-external)' || urxvt") (spawn "urxvt"))
 
  -- WM and menu bindings
  , ((mod, xK_q), spawn "xmonad --recompile && (xmonad --restart; dunstify -h string:x-canonical-private-synchronous:barless-info \"successfully recompiled\") || dunstify -h string:x-canonical-private-synchronous:barless-info \"error compiling config\"")
  , ((mod, xK_x), withPrefixArgument $ \p -> case p of
                                                   (Raw 1) -> kill >> removeWorkspace
                                                   (Raw _) -> removeWorkspace
                                                   _ -> kill)
  , ((mod, xK_m), spawn "rofi -show drun -theme launcher_light.rasi")
  , ((mod, xK_d), spawn "rofi -show run -theme launcher_light.rasi")
  -- , ((mod, xK_w), spawn "rofi -no-lazy-grab -show window -theme window_menu_light.rasi")
  , ((mod, xK_w), rws $ goToSelected myGSWindowConfig)
  -- , ((mod .|. shiftMask, xK_w), rws $ onScreen' (goToSelected myGSWindowConfig) FocusNew 1)
  -- , ((mod .|. shiftMask .|. controlMask, xK_w), rws $ onScreen' (goToSelected myGSWindowConfig) FocusNew 0)
  , ((mod .|. shiftMask, xK_w), bringWindow)
  , ((mod, xK_o), spawn "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}' -theme clipboard.rasi -m -4")
  , ((mod, xK_y), spawn "keepmenu")
  , ((mod .|. shiftMask, xK_q), spawn "\"$HOME\"/bin/powermenu.sh")
  , ((mod, xK_s), spawn "~/bin/notifs/show-status.sh")
  -- , ((mod, xK_z), spawn "~/bin/notifs/wmctrl-workspace.sh")
  -- , ((mod, xK_n), spawn "~/.config/cmus/scripts/cmus-notification.sh")

  -- Misc bindings
  , ((mod .|. shiftMask, xK_Delete), spawn "xset s activate")
  , ((mod, xK_c), spawn "if pgrep -x xbanish; then pkill xbanish; else xbanish -i 5; fi")
  , ((mod, xK_Up), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1% && ~/bin/notifs/volume.sh")
  , ((mod, xK_Down), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1% && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_MonBrightnessUp), spawn "~/bin/notifs/brightness.sh up")
  , ((0, xF86XK_MonBrightnessDown), spawn "~/bin/notifs/brightness.sh down")
  , ((0, xF86XK_Display), spawn "if xset q | grep 'DPMS is Enabled'; then xset dpms force off; fi")
  , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1% && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1% && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_AudioPlay), bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioPlay)
                                      -- , (pure True, spawn "emacsclient --eval '(my/handle-play-pause)'")
                                      -- , (pure True, spawn "playerctl play-pause")
                                      , (pure True, spawn "mpc toggle")
                                      ])
  , ((mod, xF86XK_AudioMute), bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioPlay)
                                        -- , (pure True, spawn "emacsclient --eval '(my/handle-play-pause)'")
                                        -- , (pure True, spawn "playerctl play-pause")
                                        , (pure True, spawn "mpc toggle")
                                        ])
  , ((0, xF86XK_AudioPrev), bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioPrev)
                                      , (pure True, spawn "emacsclient --eval '(my/handle-play-prev)'") ])
  , ((mod, xF86XK_AudioLowerVolume), bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioPrev)
                                               , (pure True, spawn "emacsclient --eval '(my/handle-play-prev)'") ])
  , ((0, xF86XK_AudioNext), bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioNext)
                                      , (pure True, spawn "emacsclient --eval '(my/handle-play-next)'") ])
  , ((mod, xF86XK_AudioRaiseVolume), bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioNext)
                                               , (pure True, spawn "emacsclient --eval '(my/handle-play-next)'") ])
  , ((0, xF86XK_WLAN), toggleWifi)
  , ((0, xF86XK_WLAN), toggleWifi)
  -- , ((0, xK_Print), sendKey 0 xF86XK_Memo)
  , ((0, xF86XK_Calculator), spawn "emacsclient -c --eval '(calc nil t)'")
  , ((0, xF86XK_Favorites), spawn "maim -su | xclip -selection clipboard -t image/png")

  -- Window and WS bindings
  -- , ((mod, xK_backslash), map (\w -> removeEmptyWorkspaceByTag $ W.tag w) $ withWindowSet (pure . W.visible))
  -- , ((mod, xK_backslash), do ws <- gets windowset
  --                                let x = map (\w -> W.tag $ W.workspace w) (W.visible ws)
  --                                map removeEmptyWorkspaceByTag x
  --                                return ())
  , ((mod, xK_slash), prefixToggle (do {_ <- shiftCurrentEmpty
                                           ; return ()}) $ do new <- genWS
                                                              addWorkspace new)
  , ((mod .|. shiftMask, xK_slash), rws $ do new <- shiftCurrentEmpty
                                             windows $ W.view new)
  -- , ((mod .|. shiftMask, xK_backslash), selectWorkspace def)
  , ((mod, xK_backslash), gridselectWorkspace myGSWsConfig W.greedyView)
  -- , ((mod .|. controlMask, xK_backslash), appendWorkspacePrompt def)
  , ((mod, xK_a), rws toggleWS)
  , ((mod, xK_period), moveTo Next (Not emptyWS))
  , ((mod, xK_comma), moveTo Prev (Not emptyWS))
  , ((mod, xK_t), prefixToggle markBoring clearBoring)
  -- , ((mod .|. shiftMask, xK_b), clearBoring)
  , ((mod, xK_e), withFocused $ sendMessage . maximizeRestore)
  , ((mod, xK_r), windows W.shiftMaster)
  , ((mod, xK_Tab), focusDown)
  , ((mod .|. shiftMask, xK_Tab), focusUp)
  , ((mod .|. controlMask, xK_Tab), windows W.swapDown)
  , ((mod .|. controlMask .|. shiftMask, xK_Tab), windows W.swapUp)
  , ((mod .|. controlMask, xK_h), sendMessage Shrink)
  , ((mod .|. controlMask, xK_l), sendMessage Expand)
  , ((mod, xK_space), withFocused toggleFloat)
  , ((mod .|. mod1Mask, xK_space), do sendMessage NextLayout
                                      getLayout >>= \d -> spawn $ "dunstify -r 1234 -h string:x-canonical-private-synchronous:barless-info Layout \"" ++ d ++ "\"")
  , ((mod .|. mod1Mask, xK_l), sendMessage $ Toggle REFLECTX)
  , ((mod, xK_n), withFocused $ snapMove D Nothing)
  , ((mod, xK_p), withFocused $ snapMove U Nothing)
  , ((mod, xK_f), withFocused $ snapMove R Nothing)
  , ((mod, xK_b), withFocused $ snapMove L Nothing)
  , ((mod, xK_i), prefixToggle (withFocused minimizeWindow) (withLastMinimized maximizeWindowAndFocus))
  , ((mod, xK_BackSpace), cycleScreen 1)
  , ((mod .|. shiftMask, xK_BackSpace), prefixToggle swapNextScreen $ do swapNextScreen
                                                                         cycleScreen 1)
  , ((mod, xK_bracketleft), nextScreen)
  , ((mod, xK_bracketright), prevScreen)
  , ((mod .|. shiftMask, xK_bracketleft), shiftNextScreen)
  , ((mod .|. shiftMask, xK_bracketright), shiftPrevScreen)
  
  -- Applications
  , ((mod .|. shiftMask, xK_c), spawnP "emacsclient -cqun")
  -- , ((mod .|. shiftMask, xK_e), spawn "emacsclient -cqun -F '((title . \"emacs-floating\"))'")
  -- , ((mod .|. shiftMask, xK_d), spawnP "emacsclient -cqune '(dired \"~\")' -F '((title . \"emacs-floating\"))'")
  , ((mod .|. shiftMask, xK_d), spawnP "emacsclient -cqune '(dired \"~/\")'")
  , ((mod .|. shiftMask, xK_t), spawnP "/home/rayes/bin/vpn-exclude flatpak run com.github.micahflee.torbrowser-launcher")
  , ((mod .|. shiftMask, xK_f), prefixMultiToggle
      (spawn "flatpak run io.gitlab.librewolf-community --ProfileManager")
      (spawnNew "flatpak run io.gitlab.librewolf-community --ProfileManager")
      (spawn "/home/rayes/bin/vpn-exclude flatpak run io.gitlab.librewolf-community --ProfileManager"))
  , ((mod .|. shiftMask, xK_p), spawnP "/home/rayes/bin/vpn-exclude flatpak run com.github.Eloston.UngoogledChromium")
  , ((mod .|. shiftMask, xK_g), spawnP "gimp")
  , ((mod .|. shiftMask, xK_m), spawnP "mpv --player-operation-mode=pseudo-gui --no-terminal")
  -- , ((mod .|. shiftMask, xK_m), spawnP "flatpak run io.mpv.Mpv --player-operation-mode=pseudo-gui --no-terminal")
  , ((mod .|. shiftMask, xK_z), spawnP "flatpak run org.zrythm.Zrythm")
  , ((mod .|. shiftMask, xK_a), spawnP "flatpak run net.ankiweb.Anki")
  , ((mod .|. shiftMask, xK_v), spawnP "pavucontrol")
  , ((mod .|. shiftMask, xK_n), spawnP "nyxt")
  , ((mod .|. shiftMask, xK_y), spawnP "flatpak run org.ardour.Ardour")
  , ((mod .|. shiftMask, xK_e), spawnP "flatpak run com.calibre_ebook.calibre")
  , ((mod .|. shiftMask, xK_r), spawnP "zathura")
  , ((mod .|. shiftMask, xK_o), whenMediaMount "env LUTRIS_SKIP_INIT=1 lutris lutris:rungameid/5")
  , ((mod .|. shiftMask, xK_i), whenMediaMount "lutris")
  ]
  ++
  [ ((mod, k), rws $ withPrefixArgument $ \a -> case a of
                                                  (Raw a) -> raiseNextMaybe (notifyNoHist $ "'" ++ n ++ " not open'") (M.findWithDefault w a $ M.fromList l)
                                                  _ -> raiseNextMaybe (notifyNoHist $ "'" ++ n ++ " not open'") w)
  | (k, n, w, l) <- windowKeys ]
  -- ++
  -- [ ((mod .|. shiftMask, k), rws $ withPrefixArgument $ \a -> case a of
  --                                                               (Raw a) -> raiseNextMaybeCustomFocus (\w -> withWindowSet $ \ws -> case findTag w ws of
  --                                                                                                                                    Just i -> W.shift i
  --                                                                                                                                    _ -> return ())
  --                                                                          (notifyNoHist $ "'" ++ n ++ " not open'") (M.findWithDefault w a $ M.fromList l)
  --                                                               _ -> _)
  -- | (k, n, w, l) <- windowKeys ]
  ++
  -- zip (zip (repeat (mod .|. shiftMask)) ([xK_1..xK_9] ++ [xK_0])) (map (withNthWorkspace W.shift) [0..])
  -- ++
  [ ((mod, xK_k), promote) ]
  -- [((mod, k), windowGo d False) | (k, d) <- directionKeys] ++
  -- [((mod .|. shiftMask, k), windowSwap d False) | (k, d) <- directionKeys]
  -- ++
  -- [((modMask .|. controlMask, k), sendMessage m) | (k, m) <- [(xK_j, MirrorShrink), (xK_k, MirrorExpand)]]
  -- ++
  -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f)) -- | (key, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
  -- , (m, f) <- [(0, W.view), (shiftMask, W.shift)]]
  -- ++
  -- [((modMask .|. mod1Mask, k), windows $ swapWithCurrent i)
  -- | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])]
  where
    -- directionKeys = [(xK_h, L), (xK_j, D), (xK_k, U), (xK_l, R)]
    getLayout = gets windowset >>= return . description . W.layout . W.workspace . W.current
    toggleWifi = do spawn "[ $(nmcli radio wifi) == disabled ] && nmcli radio wifi on || nmcli radio wifi off"
                    notifyNoHist "wifi toggled"
    whenMediaMount c = spawn $ "mount -l | grep /home/rayes/mnt && "
                       ++ c ++ " || dunstify -i gnome-disks -h string:x-canonical-private-synchronous:barless-info 'media not mounted'"
    prefixToggle f fp = withPrefixArgument $ \p -> case p of
                                                     (Raw _) -> fp
                                                     _ -> f
    prefixMultiToggle f fp fpp = withPrefixArgument $ \p -> case p of
                                                              (Raw 1) -> fp
                                                              (Raw _) -> fpp
                                                              _ -> f
    -- spawnP s = prefixToggle (spawn s) (newEmptyWS >>= flip spawnOn s)
    -- spawnP s = prefixMultiToggle (spawn s) (do { ws <- newEmptyWS; spawnOn ws s; windows $ W.view ws; }) (newEmptyWS >>= flip spawnOn s)
    spawnP s =  prefixMultiToggle (spawn s) (spawnNew s) (newEmptyWS >>= flip spawnOn s)
    spawnNew p = do ws <- newEmptyWS
                    spawn p
                    windows $ W.greedyView ws
    windowKeys = [ (xK_1, "professional", className =? "Chromium-browser", [ (1, className =? "zoom") ])
                 , (xK_2, "documents", className =? "Emacs" <&&> (title ~=? ".*(\\.org|) - emacs \\[(Org|PDFView)\\]"),
                     [ (1, className =? "Zathura") ] )
                 , (xK_3, "anki", className =? "Anki", [])
                 , (xK_4, "calibre", className =? "calibre", [])
                 , (xK_5, "terminal", title =? "*eshell* - emacs [Eshell] ()", [ (1, className =? "URxvt") ])
                 , (xK_6, "editor", (className =? "Emacs"
                                      <&&> (title ~=? ".* - emacs \\[(?!Emms-Browser|EMMS|Group|Server|Summary|Article|Org|PDFView|Eshell).*\\] \\((.*|)\\)")), [])
                 , (xK_7, "media", ((className =? "Emacs"
                                     <&&> (title ~=? ".* - emacs \\[(Emms-Browser|EMMS)\\] \\(\\)"))
                                   <||> title ~=? "ncmpcpp » .*"), [ (1, className =? "mpv")
                                                                   , (2, title =? "WineDesktop - Wine desktop" <||> title =? "osu!")
                                                                   , (3, className =? "Lutris") ])
                 , (xK_8, "gnus", (className =? "Emacs"
                                    <&&> (title ~=? "\\*(Group|Server|Summary|Article).*\\* - emacs \\[(Group|Server|Summary|Article)\\] \\(\\)")), [])
                 , (xK_9, "browser", className =? "Nyxt", [ (1, className =? "librewolf") ])
                 , (xK_0, "tor", className =? "Tor Browser", []) ]

-- q /^? x = fmap (\a -> not $ isPrefixOf x a) q
-- q /$? x = fmap (\a -> not $ isSuffixOf x a) q
q ~=? x = fmap (=~ x) q

findTag a s = listToMaybe [ W.tag w | w <- W.workspaces s, has a (W.stack w) ]
  where
    has _ Nothing = False
    has x (Just (W.Stack t l r)) = x `elem` (t : l ++ r)

bringWindow = withPrefixArgument $ \p -> withSelectedWindow (\w -> withWindowSet $
                                                              \ws -> case findTag w ws of
                                                                       Just i | i /= (W.currentTag ws) -> do windows $ W.shiftWin (W.currentTag ws) w
                                                                                                             case p of
                                                                                                               (Raw _) -> do ws <- screenBy 1 >>= screenWorkspace
                                                                                                                             whenJust ws $ \w -> windows (W.shift w)
                                                                                                                                                 >> windows (W.view w)
                                                                                                                             XMonad.focus w
                                                                                                               _ -> XMonad.focus w >> windows W.shiftMaster
                                                                                                             removeEmptyWorkspaceByTag i
                                                                       Nothing -> return ()) myGSWindowConfig

notifyNoHist b = spawn $ "dunstify -h string:x-canonical-private-synchronous:barless-info " ++ b

shiftCurrentEmpty = do new <- newEmptyWS
                       windows $ W.shift new
                       return new

genWS = do ws <- gets (W.workspaces . windowset)
           sort <- getSortByTag
           let ts = map (\w -> read (W.tag w) :: Int) $ sort ws
               new = show $ succ $ maximum ts
           return new
newEmptyWS = do new <- genWS
                addHiddenWorkspace new
                return new

cycleScreen i = screenBy i 
                >>= screenWorkspace 
                >>= flip whenJust (windows . W.view)

toggleFloat w = do floats <- gets $ W.floating . windowset;
                   if M.member w floats
                     then setBorders w 0 >> windows (W.sink w)
                     else resetBorders w >> positionFloatCenter w

resetBorders w = asks (borderWidth . config) >>= setBorders w

setBorders w bw = withDisplay $ \d -> io $ setWindowBorderWidth d w bw

-- rationalrect: (posx, posy, sizex, sizey)
-- positionFloat w = windows (\s -> W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s)
positionFloatCenter w = windows $ \s -> W.float w (W.RationalRect (1/4) (1/6) (1/2) (2/3)) s

-- ff is float function to run
floatAndRun ff w action = do { floats <- gets (W.floating . windowset);
                                if M.member w floats
                               then action
                               else do resetBorders w
                                       _ <- ff w
                                       action }

rws f = removeEmptyWorkspaceAfter f
-- rws f = removeEmptyWorkspaceAfterExcept ["1", "2"] f

myMouseBinds (XConfig {XMonad.modMask = mod}) = M.fromList $
  [ ((mod, 1), \w -> do focus w
                        windows W.shiftMaster
                        floatAndRun positionFloatCenter w $ Flex.mouseWindow regions w
                        myIfClick (snapMagicMove (Just snapd) (Just snapd) w)
                        -- myIfClick (snapMagicResize [R,D] (Just snapd) (Just snapd) w)
                        -- myIfClick $ snapMagicMouseResize 
    )
  , ((mod .|. controlMask, 1), (\w -> toggleFloat w))
  -- , ((mod, 2), const $ spawn "maim -us | xclip -t 'image/png' -selection clipboard")
  , ((mod, 3), mouseGesture gestures)
  -- , ((mod, 3), (\w -> do focus w
                         -- floatAndRun positionFloatCenter w (Flex.mouseWindow Flex.discrete w)
                         -- myIfClick (snapMagicResize [R,D] (Just snapd) (Just snapd) w)))
      
  , ((mod, 9), const $ rws $ toggleWS)
  , ((mod, 6), const $ spawn "~/bin/notifs/show-status.sh")
  , ((mod, 7), const $ focusDown)
  -- , ((0, 8), const $ submapDefaultWithKey (\_ -> spawn "xdotool click 8") . M.fromList $ [ ((0, 9), rws $ toggleWS) ])
  -- , ((0, 9), const $ bindFirst [ (className =? "mpv" <||> className =? "osu!", sendKey 0 xF86XK_AudioNext)
                               -- , (pure True, spawn "emacsclient --eval '(my/handle-play-next)'") ])
    ]
  where
    snapd = 400
    regions x = if | x < 0.25 -> 0
                   | x > 0.75 -> 1
                   | otherwise -> 0.5
    gestures = M.fromList [ ([U], const $ rws $ goToSelected myGSWindowConfig)
                          , ([D], \w -> toggleFloat w)
                          , ([L], const $ bringWindow)
                          , ([U,R], const $ bindFirst [ (className =? "Tor Browser" <||> className =? "Chromium-browser", sendKey controlMask xK_t) ])
                          , ([R,D], const $ rws $ do new <- shiftCurrentEmpty
                                                     windows $ W.view new)
                          , ([U,L,D], const $ raiseNextMaybe (notifyNoHist $ "Chromium not open") (className =? "Chromium-browser"))
                          , ([U,R,D], const $ raiseNextMaybe (notifyNoHist $ "Tor Browser not open") (className =? "Tor Browser"))
                          , ([R,U,L], const $ spawn "maim -su | xclip -selection clipboard -t image/png")
                          , ([], \w -> do focus w
                                          floatAndRun positionFloatCenter w (Flex.mouseWindow Flex.discrete w)) ]

myIfClick action = ifClick' 100 action (return ())

myLayouts = cut $ minimize . cut $ maximize . boringWindows $ trackFloating -- $ useTransientFor
            $ cut (voidBorders full
                   ||| normalBorders dual)
                   -- ||| normalBorders tiled)
  where
    cut = renamed [CutWordsLeft 1]
    full = renamed [XMonad.Layout.Renamed.Replace "Full"] $ Full
    -- tiled = renamed [XMonad.Layout.Renamed.Replace "Tiled"] $ ResizableTall 1 (1/20) (1/2) []
    dual = renamed [XMonad.Layout.Renamed.Replace "Dual"] $
      mkToggle (single REFLECTX) $
      TwoPanePersistent Nothing (1/20) (11/20)

myHandled = setFSBorderHook
  where
    setFSBorderHook (ClientMessageEvent _ _ _ _ win typ (action:dats)) = do
      managed <- isClient win
      wmstate <- getAtom "_NET_WM_STATE"
      fullsc <- getAtom "_NET_WM_STATE_FULLSCREEN"
      wstate <- fromMaybe [] <$> getProp32 wmstate win
      let isFull = fromIntegral fullsc `elem` wstate
          remove = 0
          add = 1
          toggle = 2
      when (managed && typ == wmstate && fi fullsc `elem` dats) $ do
        when (action == add || (action == toggle && not isFull)) $ do
          setBorders win 0
        when (action == remove || (action == toggle && isFull)) $ do
          resetBorders win
      return $ All True

myManaged = manageSpawn <+> composeOne [ -- isDialog -?> doFloat
                                       -- , isFullscreen -?> doFullFloat
                                       (isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_SPLASH") -?> doIgnore
                                       , transience
                                       , className =? "URxvt" -?> doCenterFloat
                                       , title =? "Chat" -?> doFloat
                                       , className =? "mpv" -?> doFloat
                                       , resource =? "feh" -?> doFloat
                                       , className =? "lxpolkit" -?> doFloat
                                       , className =? "Pavucontrol" -?> doFloat
                                       , resource =? "thunar" -?> doFloat
                                       , (className =? "Emacs" <&&> title =? "eshell") -?> doCenterFloat
                                       , (className =? "Emacs" <&&> title =? "Ediff") -?> doFloat
                                       , (className =? "Anki" <&&> title ~=? "(Statistics|Add|Anki: Create a hyperlink|Image Occlusion Enhanced - Add Mode|Options for Linux)") -?> doFloat
                                       , (className =? "MusE" -?> doFloat)
                                       , (className ^? "Ardour" <&&> title =? "Session Setup" -?> doFloat)
                                       , className =? "Gimp-2.10" -?> doFloat
                                       , className =? "Nvidia-settings" -?> doFloat
                                       , (className =? "LibreWolf" <&&> title =? "LibreWolf - Choose User Profile") -?> doFloat
                                       , className =? "Xdg-desktop-portal-gtk" -?> doFloat
                                       , className =? "zoom" -?> doFloat ]
