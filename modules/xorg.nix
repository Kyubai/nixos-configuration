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

  services.xserver = {
    enable = true;
    xkb.layout = "eu";
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
}

