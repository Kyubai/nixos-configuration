{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgDesktop = config.modules.desktop.tools;
in {
  options.modules.desktop.tools.enable = lib.mkEnableOption "basic desktop gui tools";

  config = lib.mkIf cfgDesktop.enable {
    environment.systemPackages = with pkgs; [
      anki
      bitwarden
      brave
      cargo
      corefonts
      # discord
      feishin
      gimp
      keepassxc
      ntfs3g # todo move to hacking/forensics module
      obsidian
      kdePackages.okular
      pavucontrol
      pulsemixer
      qbittorrent
      # vesktop # discord client, currently installed via flatpak
      veracrypt
      (vivaldi.override {
        proprietaryCodecs = true;
      })
      vivaldi-ffmpeg-codecs
      virtiofsd # for virt-manager https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
      remmina # rdp client
      signal-desktop
      syncthing
    ];

    services.flatpak.enable = true;

    # required for virt-manager
    # https://nixos.wiki/wiki/Virt-manager
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
