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
  #       dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
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
      kdePackages.xwaylandvideobridge
    ];

    services.greetd = {
      enable = true;
      settings = {
        terminal = {
          vt = 1;
        };
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          user = "mri";
        };
        initial_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          user = "mri";
        };
      };
    };
    #     services.displayManager = {
    #       autoLogin.enable = true;
    #       autoLogin.user = "mri";
    #       defaultSession = "hyprland";
    #     };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # wrapperFeatures.gtk = true;
    };
    programs.hyprlock.enable = true;

    # xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      # wlr.enable = true;
      # xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk # required for themes?
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
    };

    # I think this option is set by the wayland module
    # xdg.portal.config.sway.default = ["wlr;gtk"];
    xdg.portal.config.hyprland."org.freedesktop.impl.portal.FileChooser" = ["kde"];
    xdg.portal.config.hyprland."org.freedesktop.impl.portal.AppChooser" = ["kde"];
  };
}
