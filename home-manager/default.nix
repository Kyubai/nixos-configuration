{...}: {
  imports = [
    ./modules
  ];

  # my own modules, which I always want to be enabled
  modules.docker.enable = true;
  modules.eza.enable = true;
  modules.flatpak.enable = true;
  modules.git.enable = true;
  modules.neovim.enable = true;
  modules.theme.enable = true;
  modules.tmux.enable = true;
  modules.zsh.enable = true;

  programs.bat.enable = true;
  programs.imv.enable = true;
  programs.mpv.enable = true;
  programs.ripgrep.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # required for virt-manager
  # https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # zoxide is a cd alternative
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  home.shellAliases = {
    cat = "bat -p";
    cd = "z";
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos --show-trace --option eval-cache false && git -C /etc/nixos add -A && git -C /etc/nixos commit && git -C /etc/nixos push";
    hms = "home-manager switch --extra-experimental-features \"nix-command flakes\" --flake .#$USER /etc/nixos";
    nix-shell = "nix-shell --run zsh";
    "nix build" = "nix build --print-out-paths";
  };

  home.sessionPath = [
    "$HOME/scripts/"
    "/data/security/scripts/"
  ];

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/http" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/https" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/about" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/unknown" = ["vivaldi-stable.desktop"];
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
      "text/html" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/http" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/https" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/about" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/unknown" = ["vivaldi-stable.desktop"];
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

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
