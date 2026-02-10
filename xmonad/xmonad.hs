import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import qualified XMonad.StackSet as W
import Data.List (isPrefixOf)

myWorkspaces = ["work", "chat", "steam", "games", "music", "diy"]

myManageHook = composeAll
    [ className =? "Firefox"     --> doShift "work"
    , className =? "firefox"     --> doShift "work"
    , className =? "Antigravity" --> doShift "work"
    , className =? "ghostty"     --> doShift "work"
    , className =? "com.mitchellh.ghostty" --> doShift "work"
    , className =? "Steam"       --> doShift "steam"
    , className =? "discord"     --> doShift "chat"
    , className =? "Discord"     --> doShift "chat"
    , className =? "Cider"       --> doShift "music"
    , className =? "cider"       --> doShift "music"
    , className =? "gamescope"   --> doShift "games"
    , isSteamGame                --> doShift "games"
    ]
  where
    isSteamGame = className >>= \c -> return ("steam_app_" `isPrefixOf` c)

myLayout = avoidStruts $ spacingRaw False (Border 10 10 10 10) True (Border 10 10 10 10) True $
           tiled ||| Mirror tiled ||| Full ||| threeCol
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
     threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ docks def
        { layoutHook = myLayout
        , workspaces = myWorkspaces
        , manageHook = myManageHook <+> manageDocks <+> manageHook def
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "#7aa2f7" "" . shorten 50
                        , ppCurrent = xmobarColor "#7aa2f7" "" . wrap "[" "]"
                        , ppVisible = xmobarColor "#7aa2f7" ""
                        , ppUrgent = xmobarColor "#f7768e" ""
                        }
        , modMask = mod4Mask
        , terminal = "ghostty"
        , borderWidth = 2
        , normalBorderColor = "#1a1b26"
        , focusedBorderColor = "#7aa2f7"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((mod4Mask, xK_p), spawn "walker") -- Using walker as it is in the flake
        , ((mod4Mask, xK_b), sendMessage ToggleStruts)
        ]
