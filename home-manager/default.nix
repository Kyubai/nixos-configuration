{pkgs, ...}: {
  imports = [
    ./docker
    ./eza
    ./git
    ./i3
    ./kitty
    ./neovim
    ./ssh
    ./steam
    ./sway
    ./theme
    ./tmux
    ./vim
    ./waybar
    ./zsh
  ];

  programs.bat.enable = true;
  programs.imv.enable = true;
  programs.mpv.enable = true;
  programs.tmux = {
    enable = true;
    mouse = true;
  };
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

  # zoxide cd alternative
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
    # add nvim?
  };

#   xdg.mimeApps = {
#     enable = true;
#     associations.added = {
#       "text/html" = ["vivaldi.desktop"];
#       "x-scheme-handler/http" = ["vivaldi.desktop"];
#       "x-scheme-handler/https" = ["vivaldi.desktop"];
#       "x-scheme-handler/about" = ["vivaldi.desktop"];
#       "x-scheme-handler/unknown" = ["vivaldi.desktop"];
#     };
#     defaultApplications = {
#       "text/html" = ["vivaldi.desktop"];
#       "x-scheme-handler/http" = ["vivaldi.desktop"];
#       "x-scheme-handler/https" = ["vivaldi.desktop"];
#       "x-scheme-handler/about" = ["vivaldi.desktop"];
#       "x-scheme-handler/unknown" = ["vivaldi.desktop"];
#     };
#   };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
