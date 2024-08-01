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

  # required for virt-manager
  # https://nixos.wiki/wiki/Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
