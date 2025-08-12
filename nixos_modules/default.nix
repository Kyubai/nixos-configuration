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
    ./games.nix
    ./hyprland.nix
    ./it-sec.nix
    ./japanese-input.nix
    ./notebook.nix
    ./printing.nix
    ./sound.nix
    ./sway.nix
    ./utils.nix
    ./vmware-guest.nix
    ./work.nix
    ./xorg.nix
  ];
}
