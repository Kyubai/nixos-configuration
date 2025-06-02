{lib, ...}: {
  home.username = lib.mkDefault "root";
  home.homeDirectory = lib.mkDefault /root;
}
