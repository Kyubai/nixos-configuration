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
    # Would normally set this to fcitx, but kitty only supports ibus, and fcitx
    # provides an ibus interface. Can't use ibus for e.g. QT_IM_MODULE though,
    # because that at least breaks mumble
    home.sessionVariables.GLFW_IM_MODULE = "ibus";
    home.sessionVariables.QT_IM_MODULE = "fcitx";
    home.sessionVariables.XMODIFIERS = "@im=fcitx";

    xsession.initExtra = ''
    '';

    wayland.windowManager.sway.extraConfig = ''
    '';
  };
}
