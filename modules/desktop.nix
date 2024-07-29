{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    bitwarden
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
    vivaldi-ffmpeg-codecs
    syncthing
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
