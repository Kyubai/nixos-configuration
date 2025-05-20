{
  config,
  lib,
  ...
}: let
  cfgFlatpak = config.modules.flatpak;
in {
  options.modules.flatpak.enable = lib.mkEnableOption "enable flatpak config";
  # flatpak is enabled via nixos config
  # https://nixos.wiki/wiki/Flatpak
}
