{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
import XMonad
import XMonad.Prelude

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WindowSwallowing

-- import XMonad.Layout.NoBorders
import XMonad.Layout.VoidBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.StateFull
import XMonad.Layout.BoringWindows
import XMonad.Layout.Renamed

import XMonad.Actions.FloatSnap
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Actions.Minimize
import XMonad.Actions.PhysicalScreens
-- import XMonad.Actions.RotSlaves
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.GridSelect

import qualified XMonad.Actions.FlexibleManipulate as Flex

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import Graphics.X11.ExtraTypes.XF86

main :: IO ()
main = xmonad .
       ewmhFullscreen . ewmh .
       withNavigation2DConfig def $ myConfig

myConfig = def
           { modMask            = mod4Mask,
             borderWidth        = 3,
             focusFollowsMouse  = False,
             clickJustFocuses   = False,
             workspaces         = myWorkspaces,
             normalBorderColor  = "#dad3d0",
             focusedBorderColor = "#ba9eba",
             keys               = myKeys,
             mouseBindings      = myMouseBinds,
             layoutHook         = myLayouts,
             manageHook         = myManaged,
             handleEventHook    = myHandled
           }

getLayout :: X String
getLayout = gets windowset >>= return . description . W.layout . W.workspace . W.current

myColor color _ isFg = do
  return $ if isFg
           then ("#debcde", color)
           else ("#dad3d0", color)

myColorizer = myColor "#6c605a"

myGSConfig = (buildDefaultGSConfig myColorizer)
             { gs_cellheight = 60
             , gs_cellwidth = 270
             , gs_cellpadding = 10
             , gs_font = "xft:Cascadia Code:pixelsize=14"
             , gs_navigate = myGSNavigation
             , gs_rearranger = noRearranger
             , gs_bordercolor = "#937f74"}

myGSNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
 where navKeyMap = M.fromList [ ((0,xK_Escape), cancel)
                              , ((controlMask,xK_bracketleft), cancel)
                              , ((controlMask,xK_g), cancel)
                              , ((0,xK_Return), select)
                              -- , ((0,xK_slash) , substringSearch myGSNavigation)
                              -- , ((0,xK_s)     , substringSearch myGSNavigation)
                              , ((controlMask,xK_b)  , move (-1,0)  >> myGSNavigation)
                              -- , ((0,xK_h)     , move (-1,0)  >> myGSNavigation)
                              , ((controlMask,xK_f) , move (1,0)   >> myGSNavigation)
                              -- , ((0,xK_l)     , move (1,0)   >> myGSNavigation)
                              , ((controlMask,xK_n)  , move (0,1)   >> myGSNavigation)
                              -- , ((0,xK_j)     , move (0,1)   >> myGSNavigation)
                              , ((controlMask,xK_p)    , move (0,-1)  >> myGSNavigation)
                              -- , ((0,xK_k)     , move (0,-1)  >> myGSNavigation)
                              -- , ((0,xK_y)     , move (-1,-1) >> myGSNavigation)
                              -- , ((0,xK_i)     , move (1,-1)  >> myGSNavigation)
                              -- , ((0,xK_n)     , move (-1,1)  >> myGSNavigation)
                              -- , ((0,xK_m)     , move (1,1)   >> myGSNavigation)
                              , ((0,xK_space) , setPos (0,0) >> myGSNavigation)
                              , ((0,xK_BackSpace), transformSearchString (\s -> if s == ""
                                                                                then ""
                                                                                else init s)
                                                   >> myGSNavigation)
                              , ((controlMask,xK_u), transformSearchString (\_ -> "") >> myGSNavigation )]
       navDefaultHandler (_,s,_) = do
         transformSearchString (++ s)
         myGSNavigation


myWindowMenu = withFocused $ \w -> do
    tags <- asks (workspaces . config)
    Rectangle x y wh ht <- getSize w
    Rectangle sx sy swh sht <- gets $ screenRect . W.screenDetail . W.current . windowset
    let originFractX = (fi x - fi sx + fi wh / 2) / fi swh
        originFractY = (fi y - fi sy + fi ht / 2) / fi sht
        gsConfig = (buildDefaultGSConfig myColorizer) { gs_cellheight = 30
                                                      , gs_cellwidth = 50
                                                      , gs_cellpadding = 10
                                                      , gs_font = "xft:Cascadia Code:pixelsize=14"
                                                      , gs_navigate = myGSNavigation
                                                      , gs_rearranger = noRearranger
                                                      , gs_bordercolor = "#937f74"
                                                      , gs_originFractX = originFractX
                                                      , gs_originFractY = originFractY }
        actions = [ ("^ M", sendMessage $ maximizeRestore w)
                  , ("× Q"      , kill)
                  , ("| m"   , minimizeWindow w)
                  ] ++
                  [ ("→ " ++ tag, windows $ W.shift tag)
                  | tag <- tags ]
    runSelectedAction gsConfig actions

getSize :: Window -> X Rectangle
getSize w = do
  d  <- asks display
  wa <- io $ getWindowAttributes d w
  let x = fi $ wa_x wa
      y = fi $ wa_y wa
      wh = fi $ wa_width wa
      ht = fi $ wa_height wa
  return (Rectangle x y wh ht)


myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask,               xK_Return), spawn "emacsclient -cqe '(eshell t)' '(delete-other-windows)' ||  urxvt")
  , ((modMask .|. shiftMask, xK_Return), spawn "emacsclient -cqF '((title . \\\"emacs-floating\\\"))' -e '(eshell t)' '(delete-other-windows)'")
 
  -- WM and menu bindings
  , ((modMask, xK_q), spawn "xmonad --recompile && xmonad --restart || notify-send \"error compiling config\"")
  , ((modMask, xK_x), kill)

  , ((modMask, xK_m), spawn "rofi -show drun -theme launcher_light.rasi")
  , ((modMask, xK_d), spawn "rofi -show run -theme launcher_light.rasi")
  -- , ((modMask, xK_w), spawn "rofi -no-lazy-grab -show window -theme window_menu_light.rasi")
  -- , ((modMask, xK_w), goToSelected myGSConfig)
  , ((modMask, xK_w), goToSelected myGSConfig)
  , ((modMask .|. shiftMask, xK_w), myWindowMenu)
  , ((modMask, xK_p), spawn "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}' -theme clipboard.rasi -m -4")
  , ((modMask, xK_y), spawn "keepmenu")
  , ((modMask .|. shiftMask, xK_q), spawn "\"$HOME\"/bin/powermenu.sh")
  , ((modMask, xK_s), spawn "~/bin/notifs/show-status.sh")
  , ((modMask, xK_z), spawn "~/bin/notifs/wmctrl-workspace.sh")
  , ((modMask, xK_n), spawn "~/.config/cmus/scripts/cmus-notification.sh")

  -- Misc bindings
  , ((modMask .|. shiftMask, xK_Delete), spawn "~/bin/lock")
  , ((modMask, xK_c), spawn "if pgrep -x xbanish; then pkill xbanish; else xbanish -i 5; fi")
  , ((modMask, xK_Up), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1% && ~/bin/notifs/volume.sh")
  , ((modMask, xK_Down), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1% && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_MonBrightnessUp), spawn "~/bin/notifs/brightness.sh up")
  , ((0, xF86XK_MonBrightnessDown), spawn "~/bin/notifs/brightness.sh down")
  , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1% && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1% && ~/bin/notifs/volume.sh")
  , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && ~/bin/notifs/volume.sh")
  
  -- Window and WS bindings
  , ((modMask, xK_a), toggleWS)
  , ((modMask, xK_period), nextWS)
  , ((modMask, xK_comma), prevWS)
  , ((modMask, xK_b), markBoring)
  , ((modMask .|. shiftMask, xK_b), clearBoring)
  , ((modMask, xK_e), withFocused (sendMessage . maximizeRestore))
  , ((modMask, xK_r), windows W.shiftMaster)
  , ((modMask, xK_Tab), focusDown)
  , ((modMask .|. shiftMask, xK_Tab), focusUp)
  , ((modMask .|. controlMask, xK_Tab), windows W.swapDown)
  , ((modMask .|. controlMask .|. shiftMask, xK_Tab), windows W.swapUp)
  , ((modMask .|. controlMask, xK_h), sendMessage Shrink)
  , ((modMask .|. controlMask, xK_l), sendMessage Expand)
  , ((modMask, xK_space), withFocused toggleFloat)
  , ((modMask .|. mod1Mask, xK_space), do sendMessage NextLayout
                                          getLayout >>= \d -> spawn $"dunstify -r 1234 Layout \"" ++ d ++ "\"")
  , ((modMask, xK_i), withFocused minimizeWindow)
  , ((modMask, xK_o), withLastMinimized maximizeWindowAndFocus)
  , ((modMask, xK_BackSpace), onNextNeighbour def W.view)
  -- , ((modMask, xK_e) withFocused (sendMessage . maximizeRestore))
  
  -- Applications
  , ((modMask .|. shiftMask, xK_c), spawn "emacsclient -cqun")
  -- , ((modMask .|. shiftMask, xK_e), spawn "emacsclient -cqun -F '((title . \"emacs-floating\"))'")
  -- , ((modMask .|. shiftMask, xK_d), spawn "emacsclient -cqune '(dired \"~\")' -F '((title . \"emacs-floating\"))'")
  , ((modMask .|. shiftMask, xK_d), spawn "emacsclient -cqune '(dired \"~\")'")
  , ((modMask .|. shiftMask, xK_t), spawn "mullvad-exclude flatpak run com.github.micahflee.torbrowser-launcher")
  , ((modMask .|. shiftMask, xK_f), spawn "flatpak run io.gitlab.librewolf-community --ProfileManager")
  , ((modMask .|. shiftMask, xK_p), spawn "mullvad-exclude flatpak run com.github.Eloston.UngoogledChromium")
  , ((modMask .|. shiftMask, xK_g), spawn "flatpak run org.gimp.GIMP")
  , ((modMask .|. shiftMask, xK_z), spawn "zrythm")
  , ((modMask .|. shiftMask, xK_a), spawn "flatpak run net.ankiweb.Anki")
  , ((modMask .|. shiftMask, xK_v), spawn "pavucontrol")
  , ((modMask .|. shiftMask, xK_o), spawn "osu.AppImage")
  ]
 ++
 -- Switch workspaces, mod-{1..9}, Move workspaces mod-shift-{1..9}
 [((m .|. modMask, k), windows $ f i)
 | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
 , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
 ++
 -- Bind the hjkl keys to window operations in a particular direction
 [((modMask, k), windowGo d False) | (k, d) <- directionKeys]
 ++
 [((modMask .|. shiftMask, k), windowSwap d False) | (k, d) <- directionKeys]
 ++
 [((modMask .|. controlMask, k), sendMessage m) | (k, m) <- [(xK_j, MirrorShrink), (xK_k, MirrorExpand)]]
 ++
 -- Multi monitors
 [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
 | (key, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
 , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 ++
 [((modMask .|. mod1Mask, k), windows $ swapWithCurrent i)
 | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])]
 -- ++
 -- [((modMask .|. controlMask, k), W.shift i (W.greedyView i))
        -- W.greedyView i)
 -- | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])]
  where
    toggleFloat w = windows (\s -> if M.member w (W.floating s)
                                   then W.sink w s
                                   else W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s)
    directionKeys = [(xK_h, L), (xK_j, D), (xK_k, U), (xK_l, R)]

myMouseBinds (XConfig {XMonad.modMask = modm}) = M.fromList $
  [ ((modm,               button1), (\w -> focus w
                                           >> windows W.shiftMaster
                                           >> mouseMoveWindow w
                                           >> ifClick (snapMagicMove (Just snapd) (Just snapd) w)))
  , ((modm .|. shiftMask, button1), (\w -> focus w
                                           >> mouseMoveWindow w
                                           >> ifClick (snapMagicResize [L,R,U,D]
                                                       (Just snapd) (Just snapd) w)))
  , ((modm,               button3), (\w -> focus w
                                           >> Flex.mouseWindow Flex.discrete w
                                           >> ifClick (snapMagicResize [R,D]
                                                       (Just snapd) (Just snapd) w)))
  ] where snapd = 100

myWorkspaces = map show [1 .. 10 :: Int]

myLayouts = cut $ minimize . cut $ maximize . boringWindows
            $ cut (voidBorders full ||| normalBorders dual ||| normalBorders tiled)
  where
    cut = renamed [CutWordsLeft 1]
    full = renamed [XMonad.Layout.Renamed.Replace "Full"] $ StateFull
    tiled = renamed [XMonad.Layout.Renamed.Replace "Tiled"] $ ResizableTall 1 (1/20) (1/2) []
    dual = renamed [XMonad.Layout.Renamed.Replace "Dual"] $ TwoPanePersistent Nothing (1/20) (1/2)

myHandled = swallowEventHook (className =? "URxvt"
                             <||> title =? "*eshell*")
            (return True)

myManaged = composeAll
  [ resource =? "zoom" --> doFloat
  , className =? "mpv" --> doFloat
  , resource =? "feh" --> doFloat
  , className =? "lxpolkit" --> doFloat
  , className =? "Pavucontrol" --> doFloat
  , resource =? "thunar" --> doFloat
  , (className =? "Emacs" <&&> title =? "emacs-floating") --> doFloat
  , (className =? "Emacs" <&&> title =? "Ediff") --> doFloat
  , (className =? "Anki" <&&> title =? "Statistics") --> doFloat
  , (className =? "Anki" <&&> title =? "Add") --> doFloat
  , (className =? "Anki" <&&> title =? "Anki: Create a hyperlink") --> doFloat
  , (className =? "Anki" <&&> title =? "Image Occlusion Enhanced - Add Mode") --> doFloat
  , (className =? "Anki" <&&> title =? "Options for Linux") --> doFloat
  , className =? "Nvidia-settings" --> doFloat
  , (className =? "LibreWolf" <&&> title =? "LibreWolf - Choose User Profile") --> doFloat
  ]
  

-- Local Variables:
-- flycheck-ghc-search-path: '("./")
-- End:
