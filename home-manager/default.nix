{ ... }:
{
  imports = [
    ./zsh
    ./i3
    ./sway
    ./hyprland
    ./kitty
    ./eza
    ./vim
    ./waybar
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
