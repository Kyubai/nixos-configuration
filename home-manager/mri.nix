{...}: {
  imports = [
    ./default.nix
  ];

  # my own modules
  modules.sway.enable = true;
  modules.i3.enable = true;
  modules.hyprland.enable = true;
  modules.steam.enable = true;
  modules.opencomposite.enable = true;

  home.username = "mri";
  home.homeDirectory = /home/mri;
}
