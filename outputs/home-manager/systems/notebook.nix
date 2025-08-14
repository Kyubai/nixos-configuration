{...}: {
  imports = [
    ../base.nix
    ../cli.nix
    ../desktop.nix
  ];

  modules.hyprland = {
    enable = true;
    laptop.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1, 1920x1080, 0x0, 1";
  };

  home.stateVersion = "23.11";
}
