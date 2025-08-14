{lib, ...}: {
  home.username = lib.mkDefault "mri";
  home.homeDirectory = lib.mkDefault /home/mri;

  home.stateVersion = lib.mkDefault "23.11";
}
