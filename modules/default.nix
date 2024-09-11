{...}:
# with lib;
# with builtins; let
# nixFilesIn = dir:
#  mapAttrs (name: _: import (dir + "/${name}"))
#  (filterAttrs (name: _: hasSuffix ".nix" name)
#     (filterAttrs (name: _: !hasPrefix "default" name)
#    (readDir dir));
{
  imports = [
    ./amd.nix
    ./base.nix
    ./bluetooth.nix
    ./desktop.nix
    ./development.nix
    ./games.nix
    ./printing.nix
    ./sound.nix
    ./sway.nix
    ./utils.nix
    ./vbox-guest.nix
    ./vmware-guest.nix
    ./xorg.nix
  ];
}
