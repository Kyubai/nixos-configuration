{ pkgs, ... }:
{
  imports = [
    ./zsh
    ./i3
    ./neovim
    ./sway
    ./kitty
    ./eza
    ./vim
    ./waybar
    ./steam
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  programs.imv.enable = true;
  programs.mpv.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
