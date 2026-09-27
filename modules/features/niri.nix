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
      niri
      grim # screenshot utility
      slurp # geometry selector
      swappy # screenshot editor
      wl-clipboard # clipboard cli
      wl-screenrec # screen recording utility
      wayland
      wdisplays # manage monitors
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
      [[ "$(tty)" == /dev/tty1 ]] && niri-session
    '';

    programs.xwayland.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config.common = {
        default = ["gnome"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
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
          mode "2560x1440" refresh=240.0
          position x=2560 y=0
      }

      output "DP-3" {
          mode "2560x1440" refresh=240.0
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

      spawn-at-startup "dunst"

      binds {
          Mod+Return { spawn "kitty"; }
          Mod+Semicolon { spawn "kitty"; }
          Mod+D { spawn "wofi" "--show" "drun" "-i"; }
          Mod+C { close-window; }
          Mod+O { spawn "sh" "-c" "loginctl lock-session"; }
          Mod+V { spawn "pulsemixer"; }

          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }

          Mod+Left { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up { focus-window-up; }
          Mod+Down { focus-window-down; }

          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+J { move-window-down; }
          Mod+Shift+K { move-window-up; }

          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Space { toggle-window-floating; }
          Mod+I { move-workspace-to-monitor-right; }

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

          Mod+P { screenshot; }
          Mod+Shift+P { screenshot-screen; }

          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      }
    '';
  };
}
