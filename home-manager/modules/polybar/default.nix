{
  config,
  lib,
  ...
}: let
  cfgPolybar = config.modules.polybar;
in {
  options.modules.polybar.enable = lib.mkEnableOption "enable polybar config";

  config = lib.mkIf cfgPolybar.enable {
    xsession.windowManager.i3.config.bars = [
      {
        statusCommand = "polybar";
      }
    ];
  };
}
