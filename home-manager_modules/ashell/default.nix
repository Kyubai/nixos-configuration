{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.ashell;
in {
  options.modules.ashell = {
    enable = lib.mkEnableOption "enable ashell statusbar";
    laptop.enable = lib.mkEnableOption "enable laptop config";
  };

  config = lib.mkIf cfg.enable {
    #         wayland.windowManager.sway.config.bars = [
    #       {
    #         command = "${pkgs.ashell}/bin/ashell";
    #       }
    #     ];

    programs.ashell = {
      enable = true;
      systemd.enable = true;
      settings = {
        position = "Bottom";
        appearance = {
          scale_factor = 1.5;
          primary_color = "#7aa2f7";
          success_color = "#9ece6a";
          text_color = "#a9b1d6";
          workspaces = {
            workspace_names = [
              "一"
              "二"
              "三"
              "四"
              "五"
              "六"
              "七"
              "八"
              "九"
              "十"
            ];
          };
          workspace_colors = [
            "#7aa2f7"
            "#9ece6a"
          ];
          danger_color = {
            base = "#f7768e";
            weak = "#e0af68";
          };
          background_color = {
            base = "#1a1b26";
            weak = "#24273a";
            strong = "#414868";
          };
          secondary_color = {
            base = "#0c0d14";
          };
        };

        modules = {
          center = [
            "Window Title"
          ];
          left = [
            "Workspaces"
          ];
          right = [
            "SystemInfo"
            [
              "Clock"
              "Privacy"
              "Settings"
            ]
            "Tray"
          ];
        };

        window_title = {
          mode = "Title";
          truncate_title_after_length = 75;
        };

        clock = {
          format = "%F %R";
        };
      };
    };
  };
}
