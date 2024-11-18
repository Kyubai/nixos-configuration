{ ... }:
{
  imports = [
    ./default.nix
  ];

  # my own modules
  modules.sway.enable = true;
  modules.steam.enable = true;

  home.username = "mri";
  home.homeDirectory = /home/mri;
}
