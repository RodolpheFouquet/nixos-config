{ config, pkgs, lib, ... }:
{
  # Enable XMonad in NixOS
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Configure PAM for betterlockscreen
  security.pam.services.betterlockscreen.text = "auth include login";
  security.pam.services.i3lock.text = "auth include login";
  security.pam.services.i3lock-color.text = "auth include login";

  # Configure XMonad and Xmobar via Home Manager
  home-manager.users.${config.var.username} = { pkgs, ... }: {
    
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        import XMonad.Hooks.DynamicLog
        import XMonad.Hooks.ManageDocks
        import XMonad.Util.Run(spawnPipe)
        import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
        import XMonad.Util.SpawnOnce
        import XMonad.Util.NamedScratchpad
        import System.IO
        import System.Exit
        import XMonad.Layout.Spacing
        import XMonad.Layout.ThreeColumns
        import XMonad.Layout.Grid
        import XMonad.Layout.Magnifier
        import XMonad.Layout.MultiToggle
        import XMonad.Layout.MultiToggle.Instances
        import qualified XMonad.StackSet as W
        import Data.List (isPrefixOf)
        import qualified Data.Map as M

        scratchpads :: [NamedScratchpad]
        scratchpads = [ NS "terminal" "${pkgs.ghostty}/bin/ghostty --class=scratchpad" (className =? "scratchpad") (customFloating $ W.RationalRect 0.1 0.1 0.8 0.8) ]

        -- Helper function to toggle floating state
        toggleFloat w = windows $ \s ->
            if M.member w (W.floating s)
            then W.sink w s
            else (W.float w (W.RationalRect (1/4) (1/4) (1/2) (1/2)) s)

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
            , className =? "snapmaker-orca" --> doShift "diy"
            , isSteamGame                --> doShift "games"
            ] <+> namedScratchpadManageHook scratchpads
          where
            isSteamGame = className >>= \c -> return ("steam_app_" `isPrefixOf` c)

        myLayout = mkToggle (NBFULL ?? EOT) $ avoidStruts $ spacingRaw False (Border 10 10 10 10) True (Border 10 10 10 10) True $
                   tiled ||| Mirror tiled ||| Full ||| threeCol ||| Grid
          where
             tiled   = Tall nmaster delta ratio
             nmaster = 1
             ratio   = 1/2
             delta   = 3/100
             threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio

        myStartupHook = do
            spawnOnce "${pkgs.firefox}/bin/firefox"
            spawnOnce "${pkgs.ghostty}/bin/ghostty"
            spawnOnce "steam"
            spawnOnce "${pkgs.discord}/bin/discord"
            spawnOnce "${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr" -- Ensure cursor is set on startup

        main = do
            xmproc <- spawnPipe "${pkgs.xmobar}/bin/xmobar"
            xmonad $ docks def
                { layoutHook = myLayout
                , workspaces = myWorkspaces
                , manageHook = myManageHook <+> manageDocks <+> manageHook def
                , startupHook = myStartupHook
                , logHook = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmproc
                                , ppTitle = xmobarColor "#7aa2f7" "" . shorten 50
                                , ppCurrent = xmobarColor "#7aa2f7" "" . wrap "[" "]"
                                , ppVisible = xmobarColor "#7aa2f7" ""
                                , ppHidden = xmobarColor "#a9b1d6" ""
                                , ppHiddenNoWindows = xmobarColor "#565f89" ""
                                , ppUrgent = xmobarColor "#f7768e" ""
                                }
                , modMask = mod4Mask
                , terminal = "${pkgs.ghostty}/bin/ghostty"
                , borderWidth = 2
                , normalBorderColor = "#1a1b26"
                , focusedBorderColor = "#7aa2f7"
                } `additionalKeys`
                [ ((mod4Mask .|. shiftMask, xK_z), spawn "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim")
                , ((mod4Mask, xK_p), spawn "${pkgs.rofi}/bin/rofi -show drun") -- Using rofi instead of walker
                , ((mod4Mask, xK_t), spawn "${pkgs.ghostty}/bin/ghostty") 
                , ((mod4Mask .|. shiftMask, xK_t), withFocused toggleFloat)
                , ((mod4Mask, xK_b), sendMessage ToggleStruts)
                , ((mod4Mask, xK_f), sendMessage $ XMonad.Layout.MultiToggle.Toggle NBFULL)
                , ((mod4Mask .|. shiftMask, xK_n), io (exitWith ExitSuccess))
                , ((mod4Mask, xK_grave), namedScratchpadAction scratchpads "terminal")
                ]
                ++
                [((m .|. mod4Mask, k), windows $ f i)
                    | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
                    , (f, m) <- [(W.greedyView, 0), (\i -> W.greedyView i . W.shift i, shiftMask)]]
                `additionalKeysP`
                [ ("<XF86AudioMute>", spawn "${pkgs.alsa-utils}/bin/amixer set Master toggle")
                , ("<XF86AudioLowerVolume>", spawn "${pkgs.alsa-utils}/bin/amixer set Master 5%- unmute")
                , ("<XF86AudioRaiseVolume>", spawn "${pkgs.alsa-utils}/bin/amixer set Master 5%+ unmute")
                ]
      '';
    };

    programs.xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmobarrc;
    };

    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      shadow = true;
      settings = {
        corner-radius = 12;
        blur = {
          method = "dual_kawase";
          strength = 5;
        };
        rounded-corners-exclude = [
          "window_type = 'desktop'"
        ];
      };
    };

    services.xidlehook = {
      enable = true;
      not-when-audio = true;
      not-when-fullscreen = true;
      timers = [
        {
          delay = 300;
          command = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
        }
        {
          delay = 900;
          command = "systemctl suspend";
        }
      ];
    };
  };
}