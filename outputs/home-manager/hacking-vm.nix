{...}: {
  imports = [
    ./base.nix
    ./cli.nix
    ./desktop.nix
    ./xorg.nix
  ];

  home.stateVersion = "23.11";
}
