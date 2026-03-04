{
  config,
  self,
  lib,
  pkgs,
  ...
}:

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
        startx.enable = true;
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      videoDrivers = [
        # "vmware" # this used to fix resizing issues, but this driver is broken as of 2026-01-15
        "modesetting"
      ];
    };

    services.displayManager.gdm.enable = true;

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
