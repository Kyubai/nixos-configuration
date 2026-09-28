{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      swaybg
      pavucontrol
      grim # screenshot utility
      slurp # geometry selector
      swappy # screenshot editor
      wl-clipboard # clipboard cli
      wl-screenrec # screen recording utility
      wayland
      wdisplays # manage monitors
      playerctl
      brightnessctl
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      kdePackages.dolphin # file manager
      kdePackages.kio
      kdePackages.kdf
      kdePackages.qtsvg
      kdePackages.kio-fuse
      kdePackages.kio-extras
      kdePackages.kio-admin
      kdePackages.qtwayland
      kdePackages.plasma-integration
      kdePackages.breeze-icons
      kdePackages.kservice
      kdePackages.plasma-workspace
      shared-mime-info
    ];

    services.getty = {
      autologinUser = "mri";
      autologinOnce = true;
    };
    environment.loginShellInit = ''
      if [[ "$(tty)" == /dev/tty1 ]] && [[ -z "$WAYLAND_DISPLAY" ]]; then
        exec niri --session
      fi
    '';

    programs.xwayland.enable = true;
    programs.niri.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
      config.common = {
        default = ["gnome"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        "org.freedesktop.impl.portal.FileChooser" = ["kde"];
        "org.freedesktop.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.portal.Screenshot" = ["gnome"];
      };
    };

    services.dbus.enable = lib.mkDefault true;
    security.polkit.enable = true;
  };

  flake.homeModules.niri = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.homeModules.kitty
      self.homeModules.ashell
    ];

    services.dunst.enable = true;
    programs.wofi.enable = true;
    gtk.enable = true;

    home.pointerCursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
    };

    xdg.configFile."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "eu"
                  options "lv3:lalt_switch"
              }
          }

          mouse {
              accel-speed -0.5
              accel-profile "flat"
          }

          touchpad {
              tap
              natural-scroll
          }
      }

      output "DP-1" {
          mode "2560x1440@240.000"
          position x=2560 y=0
      }

      output "DP-3" {
          mode "2560x1440@240.000"
          position x=0 y=0
      }

      layout {
          gaps 10

          border {
              width 2
              active-color "#7aa2f7"
              inactive-color "#414868"
          }

          focus-ring {
              off
          }

          default-column-width { proportion 0.5; }
      }

      animations {
          off
      }

      screenshot-path "~/screenshots/%Y-%m-%dT%H:%M:%S_screenshot.png"

      environment {
          DISPLAY ":0"
      }

      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "dunst"
      spawn-at-startup "ashell"
      spawn-at-startup "swaybg -m fill -i \"$(find /data/media/backgrounds -type f | shuf -n 1)\""

      window-rule {
          match app-id="kitty"
          draw-border-with-background false
          background-effect {
              xray true
              blur true
          }
      }

      binds {
          Mod+Return { spawn "kitty"; }
          Mod+Semicolon { spawn "kitty"; }
          Mod+D { spawn "wofi" "--show" "drun" "-i"; }
          Mod+C { close-window; }
          Mod+O { spawn "sh" "-c" "loginctl lock-session"; }
          Mod+V { spawn "pavucontrol"; }
          Mod+E { spawn "dolphin"; }
          Mod+Shift+E { quit; }
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }

          Mod+Left { focus-column-or-monitor-left; }
          Mod+Right { focus-column-or-monitor-right; }
          Mod+Up { focus-window-up; }
          Mod+Down { focus-window-down; }
          Mod+Home { focus-column-first; }
          Mod+End { focus-column-last; }

          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+J { move-window-down; }
          Mod+Shift+K { move-window-up; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End { move-column-to-last; }

          Mod+Ctrl+Left { move-column-left-or-to-monitor-left; }
          Mod+Ctrl+Right { move-column-right-or-to-monitor-right; }

          Mod+Ctrl+H { set-column-width "-10%"; }
          Mod+Ctrl+L { set-column-width "+10%"; }
          Mod+Ctrl+J { set-window-height "-10%"; }
          Mod+Ctrl+K { set-window-height "+10%"; }

          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Space { toggle-window-floating; }
          Mod+W { toggle-column-tabbed-display; }
          Mod+Ctrl+C { center-column; }
          Mod+I { move-workspace-to-monitor-right; }
          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { reset-window-height; }
          Mod+Ctrl+R { switch-preset-window-height; }

          Mod+Comma { consume-or-expel-window-left; }
          Mod+Period { consume-or-expel-window-right; }

          Mod+BracketLeft { focus-workspace-up; }
          Mod+BracketRight { focus-workspace-down; }
          Mod+Shift+BracketLeft { move-window-to-workspace-up; }
          Mod+Shift+BracketRight { move-window-to-workspace-down; }
          Mod+Ctrl+BracketLeft { move-column-to-workspace-up; }
          Mod+Ctrl+BracketRight { move-column-to-workspace-down; }

          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
          Mod+WheelScrollRight { focus-column-right; }
          Mod+WheelScrollLeft { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft { move-column-left; }
          Mod+Shift+WheelScrollDown { focus-column-right; }
          Mod+Shift+WheelScrollUp { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Shift+3 { move-window-to-workspace 3; }
          Mod+Shift+4 { move-window-to-workspace 4; }
          Mod+Shift+5 { move-window-to-workspace 5; }
          Mod+Shift+6 { move-window-to-workspace 6; }
          Mod+Shift+7 { move-window-to-workspace 7; }
          Mod+Shift+8 { move-window-to-workspace 8; }
          Mod+Shift+9 { move-window-to-workspace 9; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          Mod+G { toggle-overview; }

          Mod+Ctrl+F1 { spawn "sh" "-c" "busctl call org.freedesktop.login1 /org/freedesktop/login1/seat/seat0 org.freedesktop.login1.Seat SwitchTo u 1"; }
          Mod+Ctrl+F2 { spawn "sh" "-c" "busctl call org.freedesktop.login1 /org/freedesktop/login1/seat/seat0 org.freedesktop.login1.Seat SwitchTo u 2"; }
          Mod+Ctrl+F3 { spawn "sh" "-c" "busctl call org.freedesktop.login1 /org/freedesktop/login1/seat/seat0 org.freedesktop.login1.Seat SwitchTo u 3"; }
          Mod+Ctrl+F4 { spawn "sh" "-c" "busctl call org.freedesktop.login1 /org/freedesktop/login1/seat/seat0 org.freedesktop.login1.Seat SwitchTo u 4"; }
          Mod+Ctrl+F5 { spawn "sh" "-c" "busctl call org.freedesktop.login1 /org/freedesktop/login1/seat/seat0 org.freedesktop.login1.Seat SwitchTo u 5"; }
          Mod+Ctrl+F6 { spawn "sh" "-c" "busctl call org.freedesktop.login1 /org/freedesktop/login1/seat/seat0 org.freedesktop.login1.Seat SwitchTo u 6"; }

          Mod+P { screenshot; }
          Mod+Shift+P { screenshot-screen; }

          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioPlay { spawn "playerctl" "play-pause"; }
          XF86AudioNext { spawn "playerctl" "next"; }
          XF86AudioPrev { spawn "playerctl" "previous"; }

          XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
          XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
      }
    '';
  };
}
