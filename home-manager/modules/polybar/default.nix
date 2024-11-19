{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgPolybar = config.modules.polybar;
in {
  options.modules.polybar.enable = lib.mkEnableOption "enable polybar config";
  config = lib.mkIf cfgPolybar.enable {

    services.polybar = {
      enable = true;
      script = "polybar bar &";
      settings = {
        "module/volume" = {
          type = "internal/pulseaudio";
          format.volume = " ";
          label.muted.text = "🔇";
          label.muted.foreground = "#666";
          ramp.volume = ["🔈" "🔉" "🔊"];
          click.right = "pavucontrol &";
        };
      };
    };

    xsession.windowManager.i3.config.bars = [
      {
        statusCommand = "${pkgs.polybar}/bin/polybar";
      }
    ];
  };
}
