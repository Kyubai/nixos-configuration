{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgPolybar = config.modules.polybar;
  customPackage = pkgs.polybar.override {i3Support = true;};
in {
  options.modules.polybar.enable = lib.mkEnableOption "enable polybar config";
  config = lib.mkIf cfgPolybar.enable {
    services.polybar = {
      enable = true;
      package = customPackage;
      script = "polybar main &";
      settings = {
        "bar/main" = {
          bottom = true;
          modules-left = "i3";
          modules-right = "date";
        };

        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%Y-%m-%d";
          time = "%H:%M";
          label = "%date% %time%";
        };

        # https://github.com/polybar/polybar/wiki/Module:-i3
        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";

          index-sort = true;

          label-focused = "%index%";
          label-focused-foreground = "#ffffff";
          label-focused-background = "#3f3f3f";
          label-focused-underline = "#fba922";
          label-focused-padding = "0";

          label-separator = "|";
          label-separator-padding = 0;
        };

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
        command = "${customPackage}/bin/polybar";
      }
    ];
  };
}
