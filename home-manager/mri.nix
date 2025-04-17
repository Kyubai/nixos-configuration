{lib, ...}: {
  imports = [
    ./default.nix
  ];

  # my own modules
  modules.sway.enable = true;
  modules.i3.enable = true;
  modules.hyprland.enable = true;
  modules.steam.enable = true;
  modules.opencomposite.enable = true;

  home.username = lib.mkDefault "mri";
  home.homeDirectory = lib.mkDefault /home/mri;
}
