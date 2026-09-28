{
  inputs,
  self,
  ...
}: {
  flake.homeModules.ashell = {pkgs, ...}: let
    unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config = pkgs.config;
    };
  in {
    programs.ashell = {
      enable = true;
      package = unstable.ashell;
      systemd.enable = false;
      settings = {
        position = "Bottom";
        region = "de-DE";
        appearance = {
          scale_factor = 1.5;
          primary_color = "#7aa2f7";
          success_color = "#9ece6a";
          text_color = "#a9b1d6";
          workspace_colors = ["#7aa2f7"];
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

        workspaces = {
          indicator_format = "NameAndIcons";
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

        settings = {
          lock_cmd = "loginctl lock-session";
          audio_sinks_more_cmd = "pavucontrol -t 3";
          audio_sources_more_cmd = "pavucontrol -t 4";
          wifi_more_cmd = "nm-connection-editor";
          vpn_more_cmd = "nm-connection-editor";
          bluetooth_more_cmd = "blueman-manager";
          remove_airplane_btn = true;
          remove_idle_btn = true;
          indicators = [
            "Battery"
            "Bluetooth"
            "Network"
            "Vpn"
            "Audio"
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
