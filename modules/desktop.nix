{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    brave
    cargo
    corefonts
    # discord
    gimp
    keepassxc
    obsidian
    pavucontrol
    pulsemixer
    vesktop
    (vivaldi.override {
      proprietaryCodecs = true;
    })
    syncthing
    vivaldi-ffmpeg-codecs
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      hplipWithPlugin
      samsung-unified-linux-driver
      samsung-unified-linux-driver_1_00_37
      samsung-unified-linux-driver_1_00_36
      splix
    ];
  };
  hardware.sane.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}
