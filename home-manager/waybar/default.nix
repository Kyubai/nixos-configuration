{ pkgs, ... }:
{
  wayland.windowManager.sway.config.bars = [
    {
      command = "${pkgs.waybar}/bin/waybar";
    }
  ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer= "bottom";
        position = "bottom";
        height = 30;
        margin-left = 0;
        margin-right = 0;
        margin-top = 0;
        margin-bottom = 0;
        spacing = 1;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "network"
          "cpu"
          "wireplumber"
          "tray"
          "clock"
        ];
      };

      # tray module
      tray = {
        icon-size = 18;
        spacing = 5;
        show-passive-items = true;
      };

      # cpu module
      cpu = {
        format = "{usage}% ";
      };

      # network module
      network = {
        # "interface": "wlp2*", // (Optional) To force the use of this interface
        interval = 1;
        format-wifi = "{bandwidthTotalBytes:>3}  "; # ({essid} {signalStrength}%)
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format-wifi = "{ipaddr} ({signalStrength}%) ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "󰀦"; # Disconnected ⚠
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      wireplumber = {
        format = "{volume}% {icon}";
        format-muted = "{volume}% 󰖁";
        format-bluetooth = "{volume}% {icon} 󰂯"; # {format_source}",
      format-bluetooth-muted = "󰖁 {icon} 󰂯"; # {format_source}",
      format-icons = [
        ""
        ""
        ""
        ];
      };

      "custom/separator" = {
        format = "{icon}";
        format-icons = "|";
        tooltip = false;
      };
    };

    style = ''
@define-color fg #ffffff;
@define-color bg #333333;
@define-color bordercolor #ffffff;
@define-color disabled #a5a5a5;
@define-color alert #f53c3c;
@define-color activegreen #8fb666;

* {
  min-height: 0;
  font-size: 14px;
  border: none;
  border-radius: 0;
  background-color: transparent;
}

window#waybar {
  color: @fg;
  background-color: transparent;
}

#workspaces button {
  color: @fg;
}

#workspaces button.urgent {
  color: @alert;
}
#workspaces button.empty {
  color: @disabled;
}
#workspaces button.focused {
  color: @disabled;
}
#workspaces button.active {
  color: #F2C187;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#language,
#backlight,
#backlight-slider,
#network,
#pulseaudio,
#wireplumber,
#wireplumber,
#custom-media,
#taskbar,
#tray,
#tray menu,
#tray > .needs-attention,
#tray > .passive,
#tray > .active,
#mode,
#idle_inhibitor,
#scratchpad,
#custom-power,
#custom-notification,
#window

#custom-power {
  color: @fg;
}

#custom-separator {
  color: @disabled;
}

#network.disconnected,
#pulseaudio.muted,
#wireplumber.muted {
  color: @alert;
}

#battery.charging,
#battery.plugged {
  color: #26a65b;
}

label:focus {
  background-color: #333333;
}

#battery.critical:not(.charging) {
  background-color: @alert;
  color: @fg;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

    '';
  };
}
