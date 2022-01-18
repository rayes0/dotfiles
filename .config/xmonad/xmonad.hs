import XMonad

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Minimize
import XMonad.Layout.TwoPane
import qualified XMonad.Layout.BoringWindows as BW

import XMonad.Actions.FloatSnap
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Actions.Minimize
import qualified XMonad.Actions.FlexibleManipulate as Flex
import XMonad.Actions.FloatSnap
import XMonad.Actions.PhysicalScreens

import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withNavigation2DConfig def $ myConfig

myConfig = def
  { modMask     = mod4Mask, -- super key
    borderWidth = 3,
    focusFollowsMouse = False,
    clickJustFocuses = False,
    workspaces = myWorkspaces,
    normalBorderColor = "#dad3d0",
    focusedBorderColor = "#a09c80",
    keys = myKeys,
    mouseBindings = myMouseBinds,
    layoutHook = minimize . BW.boringWindows $ myLayouts,
    manageHook = myManaged,
    handleEventHook = myHandled
  }

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask,               xK_Return), spawn "sh -c \"emacsclient -cqe '(eshell t)' '(delete-other-windows)'\"")
  , ((modMask .|. shiftMask, xK_Return), spawn "sh -c \"emacsclient -cqF '((title . \\\"emacs-floating\\\"))' -e '(eshell t)' '(delete-other-windows)'\"")
 
  -- WM and menu bindings
  , ((modMask, xK_q), spawn "xmonad --recompile && xmonad --restart || notify-send \"error compiling config\"")
  , ((modMask, xK_x), kill)

  , ((modMask, xK_m), spawn "rofi -show drun -theme launcher_light.rasi")
  , ((modMask, xK_d), spawn "rofi -show run -theme launcher_light.rasi")
  , ((modMask, xK_w), spawn "rofi -no-lazy-grab -show window -theme window_menu_light.rasi")
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
  , ((modMask,               xK_Tab), windows W.focusDown)
  , ((modMask .|. shiftMask, xK_Tab), windows W.focusUp)
  , ((modMask .|. controlMask, xK_h), sendMessage Shrink)
  , ((modMask .|. controlMask, xK_l), sendMessage Expand)
  , ((modMask, xK_space), withFocused toggleFloat)
  , ((modMask .|. mod1Mask, xK_space), sendMessage NextLayout)
  , ((modMask, xK_i), withFocused minimizeWindow)
  , ((modMask, xK_o), withLastMinimized maximizeWindowAndFocus)
  -- , ((modMask, xK_e) withFocused (sendMessage . maximizeRestore))
  
  -- Applications
  , ((modMask .|. shiftMask, xK_c), spawn "emacsclient -cqun")
  , ((modMask .|. shiftMask, xK_e), spawn "emacsclient -cqun -F '((title . \"emacs-floating\"))'")
  , ((modMask .|. shiftMask, xK_d), spawn "emacsclient -cqune '(dired \"~\")' -F '((title . \"emacs-floating\"))'")
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
 [((modMask, k), windowGo d False) | (k, d) <- zip [xK_h, xK_j, xK_k, xK_l] [L, D, U, R]]
 ++
 [((modMask .|. shiftMask, k), windowSwap d False) | (k, d) <- zip [xK_h, xK_j, xK_k, xK_l] [L, D, U, R]]
 ++
 [((modMask .|. controlMask, k), sendMessage m) | (k, m) <- zip [xK_j, xK_k]
     [ MirrorShrink
     , MirrorExpand]]
 ++
 -- Multi monitors
 [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 ++
 [((modMask, xK_BackSpace), onNextNeighbour def W.view)]
  where
    toggleFloat w = windows (\s -> if M.member w (W.floating s)
                                   then W.sink w s
                                   else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))

myMouseBinds (XConfig {XMonad.modMask = modm}) = M.fromList $
  [ ((modm,               button1), (\w -> focus w >> mouseMoveWindow w >> ifClick (snapMagicMove (Just snapd) (Just snapd) w)))
  , ((modm .|. shiftMask, button1), (\w -> focus w >> mouseMoveWindow w >> ifClick (snapMagicResize [L,R,U,D] (Just snapd) (Just snapd) w)))
  , ((modm,               button3), (\w -> focus w >> Flex.mouseWindow Flex.discrete w >> ifClick (snapMagicResize [R,D] (Just snapd) (Just snapd) w)))
  ] where snapd = 100

myWorkspaces = map show [1 .. 10 :: Int]

myLayouts = smartBorders dual ||| noBorders Full ||| smartBorders tiled
  where
    tiled   = ResizableTall 1 (1/20) (1/2) []
    dual = TwoPane (1/20) (1/2)

myHandled = swallowEventHook (className =? "URxvt") (return True)

myManaged = composeAll
  [ resource =? "zoom" --> doFloat
  , className =? "mpv" --> doFloat
  , resource =? "feh" --> doFloat
  , className =? "lxpolkit" --> doFloat
  , className =? "pavucontrol" --> doFloat
  , resource =? "thunar" --> doFloat
  , (resource =? "emacs" <&&> title =? "emacs-floating") --> doFloat
  , (resource =? "emacs" <&&> title =? "Ediff") --> doFloat
  , (className =? "Anki" <&&> title =? "Statistics") --> doFloat
  , (className =? "Anki" <&&> title =? "Add") --> doFloat
  , (className =? "Anki" <&&> title =? "Anki: Create a hyperlink") --> doFloat
  , className =? "Nvidia-settings" --> doFloat
  , (className =? "LibreWolf" <&&> title =? "LibreWolf - Choose User Profile") --> doFloat
  ]