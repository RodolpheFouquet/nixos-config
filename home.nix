{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./packages
    ./hyprland
    ./neovim
    ./tmux
    ./waybar
    ./hyprpaper
    ./git
  ];

  programs.starship.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      zoxide init fish | source
    '';
  };
  programs.fish.functions."sessionizer" = ''
    function sessionizer
        if test -z "$argv"
            # Use fd for faster directory discovery and include deeper nesting in ~/Code
            set -l selected_dir (fd . ~/Code ~/.config --type d --max-depth 2 --min-depth 1 | fzf)
        else
            set -l selected_dir $argv[1]
        end

        if test -n "$selected_dir"
            # Add to zoxide database
            z --add "$selected_dir" 2>/dev/null
            
            set -l selected_name (basename "$selected_dir" | tr .-/ _)
            
            if not tmux has-session -t=$selected_name 2> /dev/null
                tmux new-session -ds $selected_name -c $selected_dir
            end
            
            if test -n "$TMUX"
                tmux switch-client -t $selected_name
            else
                tmux attach-session -t $selected_name
            end
        end
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
