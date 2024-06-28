{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    brave
    cargo
    corefonts
    # discord
    gimp
    keepassxc
    (lutris.override {
      extraLibraries = pkgs: [
      ];
      extraPkgs = pkgs: [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    })
    obsidian
    pavucontrol
    pulsemixer
    vesktop
    (vivaldi.override {
      proprietaryCodecs = true;
    })
    runelite
    syncthing
    vivaldi-ffmpeg-codecs
  ];
}
