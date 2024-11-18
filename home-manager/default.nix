{...}: {
  imports = [
    ./modules
  ];

  # my own modules, which I always want to be enabled
  modules.docker.enable = true;
  modules.eza.enable = true;
  modules.flatpak.enable = true;
  modules.git.enable = true;
  modules.kitty.enable = true;
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
  };

  home.sessionVariables = {
    BROWSER = "vivaldi";
    # EDITOR is set in nvim
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/http" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/https" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/about" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/unknown" = ["vivaldi-stable.desktop"];
    };
    defaultApplications = {
      "text/html" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/http" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/https" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/about" = ["vivaldi-stable.desktop"];
      "x-scheme-handler/unknown" = ["vivaldi-stable.desktop"];
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
