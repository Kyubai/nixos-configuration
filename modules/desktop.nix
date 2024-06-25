{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    cargo
    pulsemixer
    (vivaldi.override {
      proprietaryCodecs = true;
    })
    vivaldi-ffmpeg-codecs
  ];
}
