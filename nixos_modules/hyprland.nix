{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgHyprland = config.modules.desktop.hyprland;
  #   dbus-sway-environment = pkgs.writeTextFile {
  #     name = "dbus-sway-environment";
  #     destination = "/bin/dbus-sway-environment";
  #     executable = true;
  #
  #     text = ''
  #       dbus-update-activation-environment --systemd WAYLAND_DISPLAY xdG_CURRENT_DESKTOP=sway
  #       systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  #       systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  #     '';
  #   };
in {
  options.modules.desktop.hyprland.enable = lib.mkEnableOption "hyprland desktop environment";

  config = lib.mkIf cfgHyprland.enable {
    environment.systemPackages = with pkgs; [
      grimblast # screenshot utility
      hyprpaper # wallpaper
      # https://wiki.nixos.org/wiki/Dolphin
      kdePackages.dolphin # file manager
      kdePackages.kio
      kdePackages.kdf
      kdePackages.qtsvg # icons for dolphin
      kdePackages.kio-fuse # to mount remote filesystems via FUSE
      kdePackages.kio-extras # extra protocols support (sftp, fish and more)
      kdePackages.kio-admin
      kdePackages.qtwayland # Qt wayland support
      kdePackages.plasma-integration
      kdePackages.breeze-icons
      kdePackages.kservice
      kdePackages.plasma-workspace # required for dolphin applications menu
      shared-mime-info
      slurp # geometry selector
      swappy # screenshot editor
      wl-screenrec # screen recording utility
      wayland
      wdisplays # manage monitors
      wl-clipboard # clipboard cli
      # kdePackages.xwaylandvideobridge # not present in 25.11
      # portals
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk # required for themes?
      kdePackages.xdg-desktop-portal-kde
    ];

    services.greetd = {
      enable = true;
      settings = {
        terminal = {
          vt = 1;
        };
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd Hyprland";
          user = "mri";
        };
        initial_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd Hyprland";
          user = "mri";
        };
      };
    };

    programs.xwayland.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      # wrapperFeatures.gtk = true;
    };
    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        # binPath = lib.getExe pkgs.hyprland;
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
    programs.hyprlock.enable = true;

    # xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = false; # disable wlr when using hyprland
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk # required for themes?
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        common = {
          default = ["*"];
          "org.freedesktop.portal.Settings" = ["hyprland"];
          "org.freedesktop.portal.ScreenCast" = ["hyprland"];
          "org.freedesktop.portal.Screenshot" = ["hyprland"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.FileChooser" = ["hyprland"];
          "org.freedesktop.portal.OpenURI" = ["hyprland"];
        };
        hyprland = {
          default = ["hyprland"];
          # hyprland.default = ["wlr" "kde" "gtk"];
          # hyprland."org.freedesktop.impl.portal.FileChooser" = ["kde"];
          # hyprland."org.freedesktop.impl.portal.AppChooser" = ["kde"];
          # hyprland."org.freedesktop.portal.OpenURI" = ["kde"];
        };
      };
    };
    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs, printing and others.
    services.dbus.enable = lib.mkDefault true;
    security.polkit.enable = true;
  };
}
