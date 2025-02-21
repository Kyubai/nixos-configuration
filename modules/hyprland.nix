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
      # dbus-sway-environment
      # flameshot
      grim
      lightdm
      slurp
      wayland
      wdisplays
      wl-clipboard
      xwaylandvideobridge
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    # this seems to be required for autologin, I might be able to remove this later (2024-09-11)
    # services.xserver.enable = true;
    # services.xserver.displayManager.gdm = {
    # enable = true;
    # wayland.enable = true;
    # wayland = true;
    # autoLogin.delay = "0";
    # };

    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "mri";
      defaultSession = "hyprland";
      sessionPackages = [pkgs.hyprland];
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # wrapperFeatures.gtk = true;
    };
    programs.hyprlock.enable = true;

    xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      # wlr.enable = true;
      # xdgOpenUsePortal = true;
      extraPortals = [
        # pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-kde # for file-picker
      ];
    };

    # I think this option is set by the wayland module
    # xdg.portal.config.sway.default = ["wlr;gtk"];
    xdg.portal.config.hyprland."org.freedesktop.impl.portal.FileChooser" = ["kde"];
    xdg.portal.config.hyprland."org.freedesktop.impl.portal.AppChooser" = ["kde"];
  };
}
