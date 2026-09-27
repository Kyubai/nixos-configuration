{
  inputs,
  self,
  ...
}: {
  flake.homeModules.waybar = {
    lib,
    pkgs,
    ...
  }: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "bottom";
          position = "bottom";
          height = 30;
          margin-left = 0;
          margin-right = 0;
          margin-top = 0;
          margin-bottom = 0;

          modules-left = [
            "niri/workspaces"
            "hyprland/workspaces"
            "hyprland/mode"
            "sway/workspaces"
            "sway/mode"
          ];
          modules-center = [
            "hyprland/window"
            "niri/window"
          ];
          modules-right = [
            "network"
            "cpu"
            "wireplumber"
            "tray"
            "clock"
          ];

          tray = {
            icon-size = 18;
            show-passive-items = true;
          };

          "hyprland/window" = {
            separate-outputs = true;
            icon = true;
            format = "{class}";
          };

          "niri/window" = {
            format = "{title}";
          };

          cpu = {
            format = "{usage}% ";
          };

          network = {
            interval = 1;
            format-wifi = "{bandwidthTotalBytes:>3}  ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format-wifi = "{ipaddr} ({signalStrength}%) ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "󰀦";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          wireplumber = {
            format = "{volume}% {icon}";
            format-muted = "{volume}% 󰖁";
            format-bluetooth = "{volume}% {icon} 󰂯";
            format-bluetooth-muted = "󰖁 {icon} 󰂯";
            format-icons = ["" "" ""];
          };

          clock = {
            format = "{:%F %R}";
          };
        };
      };

      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "Hack Nerd Font";
            font-size: 16px;
            min-height: 0;
        }

        window#waybar {
            background: transparent;
            color: white;
        }

        #window {
            font-weight: bold;
            font-family: "Hack Nerd Font";
        }

        #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: white;
            border-top: 2px solid transparent;
        }

        #workspaces button.focused,
        #workspaces button.active {
            color: #ffffff;
            border-top: 2px solid #9d7cd8;
        }

        #mode {
            background: #64727D;
            border-bottom: 3px solid white;
        }

        #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode, #wireplumber, #backlight {
            padding: 0 2px;
            margin: 0 12px;
        }

        #clock {
            font-weight: bold;
        }

        #network.disconnected {
            background: #f53c3c;
        }
      '';
    };
  };
}
