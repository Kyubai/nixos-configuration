{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgSway = config.modules.desktop.sway;
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in {
  options.modules.desktop.sway.enable = lib.mkEnableOption "sway desktop environment";

  config = lib.mkIf cfgSway.enable {
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

    # this seems to be required for autologin, I might be able to remove this later (2024-09-11)
    services.xserver.enable = true;
    # services.xserver.displayManager.gdm = {
    # enable = true;
    # wayland.enable = true;
    # wayland = true;
    # autoLogin.delay = "0";
    # };

    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "mri";
      defaultSession = "sway";
      sessionPackages = [pkgs.sway];
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-kde # for file-picker
      ];
    };

    # I think this option is set by the wayland module
    # xdg.portal.config.sway.default = ["wlr;gtk"];
    xdg.portal.config.sway."org.freedesktop.impl.portal.FileChooser" = ["kde"];
  };
}
