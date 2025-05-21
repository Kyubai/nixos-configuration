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
        "colors" = {
          dark-base = "#1f2335";
          light-base = "#c0caf5";

          red-dark = "#c53b53";
          red-light = "#ff757f";

          green-dark = "#41a6b5";
          green-light = "#c3e88d";

          purple-dark = "#9d7cd8";
          purple-light = "#bb9af7";

          blue-dark = "#3d59a1";
          blue-light = "#7dcfff";
        };

        "bar/main" = {
          bottom = true;
          background = "\${colors.dark-base}";
          foreground = "\${colors.light-base}";
          fixed-center = true;
          padding = "5px"; # padding to left and right of bar
          font-0 = "HackNerdMono:size=11";

          scroll-up = "#i3.prev";
          scroll-down = "#i3.next";

          modules-left = "i3";
          modules-right = "tray date";
        };

        # https://github.com/polybar/polybar/wiki/Module:-i3
        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";

          index-sort = true;
          enable-click = true;
          enable-scroll = true;

          label-mode = "%mode%";
          label-mode-padding = "2px";
          label-mode-background = "\${colors.dark-base}";

          label-focused = "%index%";
          label-focused-foreground = "\${colors.dark-base}";
          label-focused-background = "\${colors.light-base}";
          label-focused-underline = "\${colors.light-base}";
          label-focused-padding = "4px";

          label-unfocused = "%index%";
          label-unfocused-padding = "4px";

          label-visible = "%index%";
          label-visible-underline = "\${colors.light-base}";
          label-visible-padding = "4px";

          label-urgent = "%index%";
          label-urgent-foreground = "\${colors.red-light}";
          label-urgent-background = "\${colors.red-dark}";
          label-urgent-padding = "4px";

          label-separator = "|";
          label-separator-padding = "2px";
          label-separator-foreground = "\${colors.light-base}";
        };

        "module/tray" = {
          type = "internal/tray";

          format-margin = "8px";
          tray-spacing = "8px";
        };

        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%Y-%m-%d";
          time = "%H:%M";
          label = "%date% %time%";
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
