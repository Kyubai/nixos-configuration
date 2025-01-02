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
      ];
    };

    # Would normally set this to fcitx, but kitty only supports ibus, and fcitx
    # provides an ibus interface. Can't use ibus for e.g. QT_IM_MODULE though,
    # because that at least breaks mumble
    environment.variables.GLFW_IM_MODULE = "ibus";
  };
}
