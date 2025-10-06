{...}: {
  # my own modules
  modules.theme.enable = true;

  # additional programs
  programs.imv.enable = true;
  programs.mpv.enable = true;

  # additional services
  services.copyq.enable = true;

  # required for virt-manager
  # https://nixos.wiki/wiki/Virt-manager
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
    };
  };
}
