{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgDesktop = config.modules.desktop.tools;
in {
  options.modules.desktop.tools.enable = mkEnableOption "basic desktop gui tools";
  config = mkIf cfgDesktop.enable {
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
      vesktop # discord client
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
