{ ... }:
{
  imports = [
    ./default.nix
  ];

  home.username = "root";
  home.homeDirectory = /root;
}
