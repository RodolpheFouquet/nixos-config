{
  inputs,
  config,
  pkgs,
  hostType ? "mac-mini",
  ...
}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./packages/shared.nix
    ./neovim
    ./tmux
    ./git
    ./wezterm
    ./fastfetch
    # Import host-specific monitor configuration
    (./hosts + "/${hostType}/monitor.nix")
  ];

  programs.starship.enable = true;

  # Add ~/.local/bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.whitelist = {
      prefix = [ "$HOME/Code" ];
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      zoxide init fish | source
      bind \cf sessionizer
      fastfetch
      set fish_greeting
    '';
  };

  programs.fish.functions."sessionizer" = ''
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set selected (begin; echo ~; find ~/Code ~/.config -mindepth 1 -maxdepth 1 -type d -exec test -d {}/.git \; -print; end | fzf)
    end

    if test -z "$selected"
        return 0
    end

    set selected_name (basename "$selected" | tr . _)
    set tmux_running (pgrep tmux)

    if test -z "$TMUX" -a -z "$tmux_running"
        tmux new-session -s $selected_name -c $selected
        return 0
    end

    if not tmux has-session -t=$selected_name 2>/dev/null
        tmux new-session -ds $selected_name -c $selected
    end

    if test -z "$TMUX"
        tmux attach -t $selected_name
    else
        tmux switch-client -t $selected_name
    end
  '';

  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}