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
    imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];

    environment.systemPackages = with pkgs; [
      anki
      bitwarden-desktop
      brave
      chromium
      corefonts
      # discord
      feishin
      filezilla
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

    networking.networkmanager.enable = true;
    services.gnome.gnome-keyring.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.flatpak = {
      enable = true;
      packages = [
        {appId = "app.fluxer.Fluxer"; origin = "flathub";}
      ];
    };

    # required for virt-manager
    # https://nixos.wiki/wiki/Virt-manager
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };

  flake.homeModules.desktop = {pkgs, ...}: {
    programs.imv.enable = true;
    programs.mpv.enable = true;

    programs.floorp = {
      enable = true;
      package = pkgs.floorp-bin;

      policies.Cookies.Allow = [
        "https://www.youtube.com"
        "https://google.com"
        "https://tuta.com"
        "https://lieferando.de"
        "https://gmail.com"
        "https://amazon.de"
        "https://bunpro.jp"
        "https://chatgpt.com"
        "https://musicbrainz.org"
        "https://account.rewe.de"
        "https://www.paypal.com"
        "https://claude.ai"
        "https://linkedin.com"
      ];

      policies.ExtensionSettings = {
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
        "deArrow@ajay.app" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
        };
        "gdpr@cavi.au.dk" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/consent_o_matic/latest.xpi";
        };
        "sponsorBlocker@ajay.app" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };
        "treestyletab@piro.sakura.ne.jp" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tree_style_tab/latest.xpi";
        };
        "VolumeBoosterWithoutDementia@zWolfrost.github.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/better_volume_booster/latest.xpi";
        };
        "{6b733b82-9261-47ee-a595-2dda294a4d08}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/yomitan/latest.xpi";
        };
        "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube_addon/latest.xpi";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden_password_manager/latest.xpi";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium_ff/latest.xpi";
        };
      };

      profiles."default" = {
        id = 0;
        isDefault = true;
        path = "jtc1y592.default-release";
        settings = {
          "browser.startup.homepage" = "https://homepage.intern.verriegelt.net";
          "browser.startup.page" = 3;
          "browser.newtabpage.enabled" = false;
          "browser.fullscreen.autohide" = false;
          "browser.search.region" = "DE";
          "media.eme.enabled" = true;

          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.allow_list.convenience.enabled" = false;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "privacy.clearOnShutdown_v2.openWindows" = false;

          "services.sync.engine.passwords" = false;

          "noraneko.downloadbar.enable" = false;
          "noraneko.statusbar.enable" = false;
        };
      };
    };

    home.file.".floorp/profiles.ini".force = true;

    xdg.dataFile."flatpak/overrides/dev.vencord.Vesktop".text = ''
      [Environment]
      ELECTRON_OZONE_PLATFORM_HINT=wayland
    '';

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
        "application/zip" = ["org.kde.ark.desktop"];
        "application/x-tar" = ["org.kde.ark.desktop"];
        "application/x-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-bzip-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-7z-compressed" = ["org.kde.ark.desktop"];
        "application/x-rar" = ["org.kde.ark.desktop"];
        "application/pdf" = ["floorp.desktop"];
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
        "application/zip" = ["org.kde.ark.desktop"];
        "application/x-tar" = ["org.kde.ark.desktop"];
        "application/x-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-bzip-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-7z-compressed" = ["org.kde.ark.desktop"];
        "application/x-rar" = ["org.kde.ark.desktop"];
        "application/pdf" = ["floorp.desktop"];
      };
    };
  };
}
