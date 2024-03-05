{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xorgserver
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xf86videointel
    xorg.xf86videoati
    xorg.xf86videonouveau
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  services.xserver.enable = true;
  services.xserver.layout = "eu";

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
    ];
  };

  services.xserver.displayManager.startx.enable = true;

}

