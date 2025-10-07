{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgXorg = config.modules.desktop.xorg;
in {
  options.modules.desktop.xorg.enable = mkEnableOption "Xorg display server";

  config = mkIf cfgXorg.enable {
    environment.systemPackages = with pkgs; [
      xorg.xorgserver
      xorg.xf86inputevdev
      xorg.xf86inputsynaptics
      xorg.xf86inputlibinput
      # xorg.xf86videointel
      xorg.xf86videoati
      # xorg.xf86videonouveau
      xsel
    ];

    services.xserver = {
      enable = true;
      xkb.layout = "eu";
      xkb.options = "compose:ralt";
      displayManager = {
        gdm.enable = true;
        startx.enable = true;
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      # guest additions resize fix
      videoDrivers = ["vmware"];
    };

    xdg.portal = {
      enable = true;
      config.common = {
        default = ["kde"]; # test only
        "org.freedesktop.impl.portal.FileChooser" = ["kde"];
        "org.freedesktop.portal.FileChooser" = ["kde"];
        "org.freedesktop.impl.portal.AppChooser" = ["kde"];
      };
    };
  };
}
