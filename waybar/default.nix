{ pkgs, ... }:

{
  # Enable the Waybar program
  programs.waybar.enable = true;

  # --- Waybar Settings ---
  # This section defines the modules and their placement on the bar.
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 35;
      modules-left = [
        "custom/cow"
        "hyprland/workspaces"
        "hyprland/mode"
      ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "custom/gpu-temp"
        "clock"
        "tray"
      ];

      # --- Module Configurations ---
      "custom/cow" = {
        format = "󰆚 ";
      };

      "hyprland/workspaces" = {
        format = "{name}";
        all-outputs = true;
        persistent_workspaces = { "*" = [ 1 2 3 4 5 ]; };
      };

      "hyprland/window" = {
        format = "{}";
        max-length = 50;
      };

      tray = {
        icon-size = 18;
        spacing = 10;
      };

      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%d/%m/%Y}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " Muted";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
          ];
        };
        on-click = "pavucontrol";
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = " {ifname}";
        format-disconnected = "Disconnected ";
        tooltip-format = "{ifname} via {gwaddr} ";
        #        on-click = "nm-connection-editor";
      };

      cpu = {
        format = " {usage}%";
        tooltip = true;
      };

      memory = {
        format = " {}%";
      };
      temperature = {
        thermal-zone = 2;
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 80;
        format-critical = " {temperatureC}°C";
        format = " {temperatureC}°C";
      };

      "custom/gpu-temp" = {
        exec = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
        format = " {}°C";
        interval = 2;
        tooltip = false;
      };
    };
  };

  # --- Waybar Styling (CSS) ---
  # This section uses CSS to style the bar and its modules.
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font";
        font-size: 14px;
        min-height: 0;
    }

    window#waybar {
        background: rgba(40, 40, 40, 0.9); /* Gruvbox background #282828 */
        color: #ebdbb2; /* Gruvbox foreground */
    }

    #workspaces button {
        padding: 0 10px;
        background: transparent;
        color: #ebdbb2;
        border-bottom: 2px solid transparent;
    }

    #workspaces button.active {
        color: #83a598; /* Gruvbox blue */
        border-bottom: 2px solid #83a598;
    }

    #workspaces button:hover {
        background: #3c3836; /* Gruvbox lighter background */
    }

    #clock, #pulseaudio, #network, #cpu, #memory, #temperature, #custom-gpu-temp, #tray {
        padding: 0 10px;
        margin: 0 4px;
        color: #ebdbb2;
    }

    #window {
        font-weight: bold;
    }

    #custom-cow {
        padding: 0 15px;
        margin: 0 8px;
        font-size: 18px;
        color: #fe8019; /* Gruvbox light orange */
    }

    #mode {
        padding: 0 10px;
        margin: 0 4px;
        background: #fabd2f; /* Gruvbox yellow */
        color: #282828; /* Dark text on yellow */
        font-weight: bold;
        border-radius: 3px;
    }
  '';
}
