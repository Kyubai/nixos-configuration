{ ... }:
{
  imports = [
    ./zsh
    ./i3
    ./hyprland
    ./kitty
    ./eza
    ./vim
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
