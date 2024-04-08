{ ... }:
{
  imports = [
    ./zsh
    ./i3
    ./hyprland
    ./kitty
  ];

  home = {
    username = "mri";
    homeDirectory = "/home/mri";
  };


  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
