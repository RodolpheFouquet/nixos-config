{ pkgs, ... }:

{
  programs.walker = {
    enable = true;
    runAsService = true;
  };

  # Create walker config files
  xdg.configFile."walker/config.toml".text = ''
    [[modules]]
    name = "applications"
    prefix = ""

    [[modules]]
    name = "runner"
    prefix = ">"

    [search]
    placeholder = "Search..."

    [ui]
    borders = "rgba(102, 92, 84, 1.0)"  # Gruvbox bg3
    fullscreen = false
    height = 400
    scrollbar_policy = "never"
    width = 600
    window_background = "rgba(40, 40, 40, 0.95)"  # Gruvbox bg0 with transparency

    [ui.anchors]
    bottom = false
    left = false
    right = false
    top = false

    [theme]
    name = "gruvbox"
  '';

  # Create gruvbox theme TOML file
  xdg.configFile."walker/themes/gruvbox.toml".text = ''
    [ui.anchors]
    bottom = true
    left = true
    right = true
    top = true

    [ui.window]
    h_align = "fill"
    v_align = "fill"

    [ui.window.box]
    h_align = "center"
    width = 600

    [ui.window.box.bar]
    orientation = "horizontal"
    position = "end"

    [ui.window.box.bar.entry]
    h_align = "fill"
    h_expand = true

    [ui.window.box.bar.entry.icon]
    h_align = "center"
    h_expand = true
    pixel_size = 24
    theme = ""

    [ui.window.box.margins]
    top = 200

    [ui.window.box.scroll.list]
    marker_color = "#d79921"  # Gruvbox yellow
    max_height = 400
    max_width = 600
    min_width = 600
    width = 600

    [ui.window.box.scroll.list.item.activation_label]
    h_align = "fill"
    v_align = "fill"
    width = 20
    x_align = 0.5
    y_align = 0.5

    [ui.window.box.scroll.list.item.icon]
    pixel_size = 26
    theme = ""

    [ui.window.box.scroll.list.margins]
    top = 8

    [ui.window.box.search.prompt]
    name = "prompt"
    icon = "edit-find"
    theme = ""
    pixel_size = 18
    h_align = "center"
    v_align = "center"

    [ui.window.box.search.clear]
    name = "clear"
    icon = "edit-clear"
    theme = ""
    pixel_size = 18
    h_align = "center"
    v_align = "center"

    [ui.window.box.search.input]
    h_align = "fill"
    h_expand = true
    icons = true

    [ui.window.box.search.spinner]
    hide = true
  '';

  # Create custom gruvbox theme
  xdg.configFile."walker/themes/gruvbox.css".text = ''
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

    #window,
    #box,
    #aiScroll,
    #aiList,
    #search,
    #password,
    #input,
    #prompt,
    #clear,
    #typeahead,
    #list,
    child,
    scrollbar,
    slider,
    #item,
    #text,
    #label,
    #bar,
    #sub,
    #activationlabel {
      all: unset;
      font-family: "Droid Sans Mono Nerd Font";
    }

    #window {
      color: @fg1;
      background: @bg0;
    }

    #box {
      border-radius: 8px;
      background: @bg0;
      padding: 16px;
      border: 2px solid @bg3;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.5);
    }

    #search {
      background: @bg1;
      padding: 12px;
      border: 1px solid @bg3;
      border-radius: 4px;
      margin-bottom: 8px;
    }

    #prompt {
      margin-left: 4px;
      margin-right: 12px;
      color: @fg3;
    }

    #clear {
      color: @fg1;
      margin-right: 4px;
    }

    #input {
      background: none;
      color: @fg1;
      font-size: 16px;
    }

    #input placeholder {
      color: @fg3;
    }

    #typeahead {
      color: @fg3;
    }

    child {
      padding: 8px;
      border-radius: 4px;
      margin: 2px 0;
    }

    child:selected {
      background: @bg2;
      border: 1px solid @yellow;
    }

    child:hover {
      background: @bg1;
    }

    #icon {
      margin-right: 8px;
    }

    #text {
      color: @fg1;
    }

    #label {
      font-weight: 500;
      color: @fg0;
    }

    #sub {
      color: @fg3;
      font-size: 0.9em;
    }

    #activationlabel {
      color: @yellow;
      font-weight: bold;
    }
  '';
}