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
        # spacing = 1;

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
        # spacing = 5;
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
/*
#workspaces {
    padding: 0 5px;
}
*/

#workspaces button {
    padding: 0 5px;
    background: transparent;
    color: white;
    border-top: 2px solid transparent;
}

#workspaces button.focused {
    color: #ffffff;
    border-top: 2px solid #9d7cd8;
}

#mode {
    background: #64727D;
    border-bottom: 3px solid white;
}

#clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
    padding: 0 3px;
    margin: 0 3px;
}

#clock {
    font-weight: bold;
}

#battery {
}

#battery icon {
    color: red;
}

#battery.charging {
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: black;
    }
}

#battery.warning:not(.charging) {
    color: white;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#cpu {
}

#memory {
}

#network {
}

#network.disconnected {
    background: #f53c3c;
}

#pulseaudio {
}

#pulseaudio.muted {
}

#tray {
}
    '';
  };
}
