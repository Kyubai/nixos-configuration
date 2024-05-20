{ pkgs, ... }:
{
  imports = [
    ./zsh
    ./i3
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
    # platformTheme = "gnome";
    style.name = "adwaita-dark";
  };

  programs.imv.enable = true;
  programs.mpv.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
