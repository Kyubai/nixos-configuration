{lib, ...}: {
  home.username = lib.mkDefault "mri";
  home.homeDirectory = lib.mkDefault /home/mri;
}
