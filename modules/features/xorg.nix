{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.xorg = {pkgs, ...}: {
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
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.xdg-desktop-portal-kde # for file-picker
      ];
      config.common = {
        default = ["kde"]; # test only
        "org.freedesktop.impl.portal.FileChooser" = ["kde"];
        "org.freedesktop.portal.FileChooser" = ["kde"];
        "org.freedesktop.impl.portal.AppChooser" = ["kde"];
      };
    };
  };

  flake.homeModules.i3 = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.homeModules.polybar
      self.homeModules.kitty
    ];
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty";
        keybindings = lib.mkOptionDefault {
          "Mod4+semicolon" = "exec kitty"; # 47 is Semicolon
        };
        window = {
          titlebar = false;
          hideEdgeBorders = "both";
        };
        floating = {
          titlebar = false;
        };
      };
    };
  };
}
