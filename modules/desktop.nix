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
}
