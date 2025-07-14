{ pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };
    
    style = ''
      /* Gruvbox color scheme */
      @define-color bg0 #282828;
      @define-color bg1 #3c3836;
      @define-color bg2 #504945;
      @define-color bg3 #665c54;
      @define-color bg4 #7c6f64;
      @define-color fg0 #fbf1c7;
      @define-color fg1 #ebdbb2;
      @define-color fg2 #d5c4a1;
      @define-color fg3 #bdae93;
      @define-color fg4 #a89984;
      @define-color red #cc241d;
      @define-color green #98971a;
      @define-color yellow #d79921;
      @define-color blue #458588;
      @define-color purple #b16286;
      @define-color aqua #689d6a;
      @define-color orange #d65d0e;

      window {
        margin: 0px;
        border: 2px solid @bg3;
        background-color: @bg0;
        border-radius: 8px;
        font-family: "Droid Sans Mono Nerd Font";
        font-size: 14px;
      }

      #input {
        margin: 8px;
        padding: 12px;
        color: @fg1;
        background-color: @bg1;
        border: 1px solid @bg3;
        border-radius: 4px;
        font-size: 16px;
      }

      #input:focus {
        border-color: @yellow;
        outline: none;
      }

      #inner-box {
        margin: 8px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 8px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 8px;
        border: none;
        color: @fg1;
      }

      #entry {
        margin: 2px;
        padding: 8px;
        border: none;
        border-radius: 4px;
        background-color: transparent;
      }

      #entry:selected {
        background-color: @bg2;
        color: @fg0;
        border: 1px solid @yellow;
      }

      #entry:hover {
        background-color: @bg1;
      }

      #entry img {
        margin-right: 8px;
      }
    '';
  };
}