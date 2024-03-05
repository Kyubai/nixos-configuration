{ username, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.sharedModules = [(import ./common.nix)];

  home-manager.users.${username} = {
    home.stateVersion = "23.11";
  #   /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };
  

  # programs.home-manager.enable = true;
}
