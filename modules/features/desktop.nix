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
      system = pkgs.stdenv.hostPlatform.system;
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
      tutanota-desktop
      # syncthing
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

  flake.homeModules.desktop = {
    programs.imv.enable = true;
    programs.mpv.enable = true;

    services.copyq.enable = true;

    home.sessionVariables = {
      BROWSER = "floorp";
    };

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "text/html" = ["floorp.desktop"];
        "x-scheme-handler/http" = ["floorp.desktop"];
        "x-scheme-handler/https" = ["floorp.desktop"];
        "x-scheme-handler/about" = ["floorp.desktop"];
        "x-scheme-handler/unknown" = ["floorp.desktop"];
        "image/bmp" = ["imv-dir.desktop"];
        "image/gif" = ["imv-dir.desktop"];
        "image/jpeg" = ["imv-dir.desktop"];
        "image/jpg" = ["imv-dir.desktop"];
        "image/pjpeg" = ["imv-dir.desktop"];
        "image/png" = ["imv-dir.desktop"];
        "image/tiff" = ["imv-dir.desktop"];
        "image/webp" = ["imv-dir.desktop"];
        "image/x-bmp" = ["imv-dir.desktop"];
        "image/x-pcx" = ["imv-dir.desktop"];
        "image/x-png" = ["imv-dir.desktop"];
        "image/x-portable-anymap" = ["imv-dir.desktop"];
        "image/x-portable-bitmap" = ["imv-dir.desktop"];
        "image/x-portable-graymap" = ["imv-dir.desktop"];
        "image/x-portable-pixmap" = ["imv-dir.desktop"];
        "image/x-tga" = ["imv-dir.desktop"];
        "image/x-xbitmap" = ["imv-dir.desktop"];
        "image/heif" = ["imv-dir.desktop"];
        "image/avif" = ["imv-dir.desktop"];
        "video/mp4" = ["mpv.desktop"];
        "video/x-matroska" = ["mpv.desktop"];
        "video/webm" = ["mpv.desktop"];
        "video/quicktime" = ["mpv.desktop"];
        "video/x-msvideo" = ["mpv.desktop"];
        "video/mpeg" = ["mpv.desktop"];
        "video/3gpp" = ["mpv.desktop"];
      };
      defaultApplications = {
        "text/html" = ["floorp.desktop"];
        "x-scheme-handler/http" = ["floorp.desktop"];
        "x-scheme-handler/https" = ["floorp.desktop"];
        "x-scheme-handler/about" = ["floorp.desktop"];
        "x-scheme-handler/unknown" = ["floorp.desktop"];
        "image/bmp" = ["imv-dir.desktop"];
        "image/gif" = ["imv-dir.desktop"];
        "image/jpeg" = ["imv-dir.desktop"];
        "image/jpg" = ["imv-dir.desktop"];
        "image/pjpeg" = ["imv-dir.desktop"];
        "image/png" = ["imv-dir.desktop"];
        "image/tiff" = ["imv-dir.desktop"];
        "image/webp" = ["imv-dir.desktop"];
        "image/x-bmp" = ["imv-dir.desktop"];
        "image/x-pcx" = ["imv-dir.desktop"];
        "image/x-png" = ["imv-dir.desktop"];
        "image/x-portable-anymap" = ["imv-dir.desktop"];
        "image/x-portable-bitmap" = ["imv-dir.desktop"];
        "image/x-portable-graymap" = ["imv-dir.desktop"];
        "image/x-portable-pixmap" = ["imv-dir.desktop"];
        "image/x-tga" = ["imv-dir.desktop"];
        "image/x-xbitmap" = ["imv-dir.desktop"];
        "image/heif" = ["imv-dir.desktop"];
        "image/avif" = ["imv-dir.desktop"];
        "video/mp4" = ["mpv.desktop"];
        "video/x-matroska" = ["mpv.desktop"];
        "video/webm" = ["mpv.desktop"];
        "video/quicktime" = ["mpv.desktop"];
        "video/x-msvideo" = ["mpv.desktop"];
        "video/mpeg" = ["mpv.desktop"];
        "video/3gpp" = ["mpv.desktop"];
      };
    };
  };
}
