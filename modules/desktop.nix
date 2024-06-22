{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    pulsemixer
    (vivaldi.override {
      proprietaryCodecs = true;
    })
    vivaldi-ffmpeg-codecs
  ];
}
