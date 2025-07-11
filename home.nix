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
  ];

  programs.starship.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
    '';
  };
  programs.fish.functions."sessionizer" = ''
    function sessionizer
        if test -z "$argv"
            set -l selected_dir (find ~/Code ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
        else
            set -l selected_dir $argv[1]
        end

        if test -n "$selected_dir"
            set -l selected_name (basename "$selected_dir" | tr . _)
            
            if not tmux has-session -t=$selected_name 2> /dev/null
                tmux new-session -ds $selected_name -c $selected_dir
            end
            
            tmux switch-client -t $selected_name
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
