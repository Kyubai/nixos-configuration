{...}: {
  imports = [
    ./base.nix
    ./cli.nix
    ./desktop.nix
    ./gaming.nix
    ./wayland.nix
  ];

  home.stateVersion = "23.11";
}
