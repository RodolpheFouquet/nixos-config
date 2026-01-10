{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    baseIndex = 1;
    mouse = true;
    escapeTime = 10;
    focusEvents = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      tokyo-night-tmux
    ];

    extraConfig = ''
      # Set custom prefix
      set -g prefix C-a
      unbind C-b
      bind-key C-a send-prefix

      # Set pane numbering to start from 1
      set-option -g pane-base-index 1

      # Configure continuum plugin
      set -g @continuum-restore 'on'

      # Sessionizer shortcut
      bind-key f run-shell "tmux new-window tms"
    '';
  };
  xdg.configFile."tms/config.toml".text = ''
    search_dirs = [
      { path = "/home/vachicorne/Code", depth = 2 }
    ]
  '';
}
