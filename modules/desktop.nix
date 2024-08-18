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
    veracrypt
    (vivaldi.override {
      proprietaryCodecs = true;
    })
    vivaldi-ffmpeg-codecs
    virtiofsd # for virt-manager https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
    signal-desktop
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
