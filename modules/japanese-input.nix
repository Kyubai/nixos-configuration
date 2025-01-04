{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.input.japanese;
in {
  options.modules.input.japanese.enable = lib.mkEnableOption "enable japanese input method";

  config = lib.mkIf cfg.enable {
    # following from: https://github.com/infinisil/system/blob/07534666e0592d9ceb1fc157dc48baa7b1494d99/config/modules/japanese-input/default.nix
    # Only really for env vars
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [
        pkgs.fcitx5-mozc
        pkgs.fcitx5-gtk
        pkgs.fcitx5-configtool
      ];
    };

    i18n.inputMethod.fcitx5.waylandFrontend = true;
  };
}
