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
  programs.bat.enable = true;
  programs.tmux = {
    enable = true;
    mouse = true;
  };

  # zoxide cd alternative
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  home.shellAliases = {
    cat = "bat -p";
    cd = "z";
  };

  home.sessionVariables = {
    BROWSER = "vivaldi";
    # add nvim?
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
