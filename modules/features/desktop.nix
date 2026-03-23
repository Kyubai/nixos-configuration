{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.desktop = {
    pkgs,
    nixpkgs-unstable,
    ...
  }: let
    unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config = pkgs.config;
    };
  in {
    environment.systemPackages = with pkgs; [
      anki
      bitwarden-desktop
      brave
      chromium
      corefonts
      # discord
      feishin
      filezilla
      unstable.floorp-bin
      gimp
      krita
      keepassxc
      ntfs3g # TODO move to hacking/forensics module
      obsidian
      kdePackages.okular
      pavucontrol
      pulsemixer
      qbittorrent
      # vesktop # discord client, currently installed via flatpak
      # veracrypt
      virtiofsd # for virt-manager https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
      virtualbox
      remmina # rdp client
      unstable.signal-desktop
      syncthing
    ];

    services.gnome.gnome-keyring.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.flatpak.enable = true;

    # required for virt-manager
    # https://nixos.wiki/wiki/Virt-manager
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
