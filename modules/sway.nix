{ pkgs, ... }:
let
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
in
{
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
    sessionPackages = [ pkgs.sway ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
