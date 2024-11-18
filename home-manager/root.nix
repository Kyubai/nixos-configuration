{ ... }:
{
  imports = [
    ./default.nix
  ];

  # my own modules
  modules.sway.enable = true;
  modules.steam.enable = true;

  home.username = "root";
  home.homeDirectory = /root;
}
