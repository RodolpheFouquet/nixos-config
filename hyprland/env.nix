{ config, ... }:

let
  vars = import ../variables.nix;
in
{
  wayland.windowManager.hyprland.settings = {
    env = [
      "NIXOS_OZONE_WL, 1"
      "NIXPKGS_ALLOW_UNFREE, 1"
      "XDG_CURRENT_DESKTOP, Hyprland"
      "XDG_SESSION_TYPE, wayland"
      "XDG_SESSION_DESKTOP, Hyprland"
      "GDK_BACKEND, wayland, x11"
      "CLUTTER_BACKEND, wayland"
      "QT_QPA_PLATFORM=wayland;xcb"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
      "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
      "SDL_VIDEODRIVER, x11"
      "MOZ_ENABLE_WAYLAND, 1"
      "GDK_SCALE,1"
      "QT_SCALE_FACTOR,1"
      "EDITOR,nvim"
      "TERMINAL,ghostty"
      "XDG_TERMINAL_EMULATOR,ghostty"
      "HYPRCURSOR_THEME,Bibata-Modern-Classic"
      "DXVK_ENABLE_NVAPI,1"
      "PROTON_ENABLE_NVAPI,1"
      "__GL_SHADER_DISK_CACHE,1"
      "__GL_SHADER_DISK_CACHE_SKIP_CLEANUP,1"
      "__GL_SHADER_DISK_CACHE_SIZE,10737418240"
      "__GL_SHADER_DISK_CACHE_PATH,${vars.userHome vars.username}/.shaders"
    ];
  };
}
