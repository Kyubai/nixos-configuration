{
  config,
  lib,
  ...
}: let
  cfgHyprland = config.modules.hyprland;
in {
  options.modules.hyprland.enable = lib.mkEnableOption "enable hyprland windows manager";

  config = lib.mkIf cfgHyprland.enable {
    modules.kitty.enable = true; # kitty is configured as terminal in config

    wayland.windowManager.hyprland = {
      enable = true;
      # enableNvidiaPatches = true;
      xwayland.enable = true;
      extraConfig = import ./hyprland.conf;
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
    home.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    home.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";
    home.sessionVariables.XDG_CURRENT_DESKTOP = "Hyprland";
    home.sessionVariables.XDG_SESSION_DESKTOP = "Hyprland";
    home.sessionVariables.XDG_SESSION_TYPE = "wayland";
    home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";
    home.sessionVariables.NIXOS_XDG_OPEN_USE_PORTAL = "1";

    home.file.".hyprlandinitrc" = {
      source = ./.hyprlandinitrc;
      executable = true;
    };
  };
}
