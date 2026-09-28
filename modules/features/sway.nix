{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.sway = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      grimblast # screenshot utility
      hyprpaper # wallpaper
      # https://wiki.nixos.org/wiki/Dolphin
      kdePackages.dolphin # file manager
      kdePackages.kio
      kdePackages.kdf
      kdePackages.qtsvg # icons for dolphin
      kdePackages.kio-fuse # to mount remote filesystems via FUSE
      kdePackages.kio-extras # extra protocols support (sftp, fish and more)
      kdePackages.kio-admin
      kdePackages.qtwayland # Qt wayland support
      kdePackages.plasma-integration
      kdePackages.breeze-icons
      kdePackages.kservice
      kdePackages.plasma-workspace # required for dolphin applications menu
      shared-mime-info
      slurp # geometry selector
      swappy # screenshot editor
      wl-screenrec # screen recording utility
      wayland
      wdisplays # manage monitors
      wl-clipboard # clipboard cli
      xdg-desktop-portal-gtk # required for themes?
      kdePackages.xdg-desktop-portal-kde
    ];
    environment.sessionVariables = {
      WLR_RENDERER = "pixman";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.getty = {
      autologinUser = "mri";
      autologinOnce = true;
    };
    environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && sway
    '';

    systemd.user.services.vmwgfxctrl-sway-resolution = {
      description = "Update Sway Virtual-1 resolution from vmwgfxctrl topology";

      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];

      path = with pkgs; [
        sway
        gnugrep
        coreutils
        open-vm-tools
      ];

      script = ''
        set -eu

        state_file="$XDG_RUNTIME_DIR/vmwgfxctrl-sway-resolution.last"

        get_mode() {
          vmwgfxctrl --print-topology \
            | grep -F 'Modes:' -A 1 \
            | grep -F '0:' \
            | cut -d ' ' -f 5
        }

        while true; do
          mode="$(get_mode || true)"

          if [ -n "$mode" ]; then
            old_mode=""
            if [ -f "$state_file" ]; then
              old_mode="$(cat "$state_file")"
            fi

            if [ "$mode" != "$old_mode" ]; then
              swaymsg -- output Virtual-1 mode --custom "$mode"
              printf '%s\n' "$mode" > "$state_file"
            fi
          fi

          sleep 2
        done
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 2;
      };
    };

    programs.sway.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk # required for themes?
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        common = {
          default = ["*"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
      };
    };

    services.dbus.enable = lib.mkDefault true;
    security.polkit.enable = true;
  };

  flake.homeModules.sway = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.homeModules.ashell
      self.homeModules.kitty
    ];
    services.dunst.enable = true; # notification deamon
    programs.wofi.enable = true; # dmenu

    gtk.enable = true; # required for portals?

    home.pointerCursor = {
      hyprcursor.enable = true;
      package = pkgs.nordzy-cursor-theme; # cursor theme
      name = "Nordzy-hyprcursors";
    };

    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.outputs = [
            {
              criteria = "Virtual-1";
              mode = "preferred";
            }
          ];
        }
      ];
    };

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];
      extraSessionCommands = ''
        export SDL_VIDEODRIVER="wayland"
        export QT_QPA_PLATFORM="wayland"
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
      extraConfig = ''
        bindsym Mod4+i move workspace to output right
        for_window [shell="xwayland"] title_format "[XWayland] %title"
        exec_always xrandr --output $(xrandr --listactivemonitors | sed 's, ,/,g' | tail -n +2 | sed 's,2560,3000,g' | sort -t '/' -n -k4 -r | sed 's,.*/,,g' | head -n1) --primary
        bindsym Mod4+p exec --no-startup-id grim -g "$(slurp)" - | wl-copy
        bindsym Mod4+Shift+p exec --no-startup-id grim -g "$(slurp)" ~/screenshots/$(date -Iseconds)_screenshot.png
      '';
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        menu = "wofi -S drun -i";
        input = {
          "*" = {
            xkb_layout = "eu";
            xkb_options = "lv3:lalt_switch";
          };
        };
        keybindings = lib.mkOptionDefault {
          "Mod4+semicolon" = "exec kitty";
          "Mod4+o" = "exec loginctl lock-session";
          "Mod4+v" = "exec pulsemixer";
          "Mod4+c" = "kill";
          "Mod4+h" = "focus left";
          "Mod4+j" = "focus down";
          "Mod4+k" = "focus up";
          "Mod4+l" = "focus right";
          "Mod4+Shift+h" = "move left";
          "Mod4+Shift+j" = "move down";
          "Mod4+Shift+k" = "move up";
          "Mod4+Shift+l" = "move right";
          "Mod4+f" = "fullscreen toggle";
          "Mod4+space" = "floating toggle";
        };
        window = {
          titlebar = false;
          hideEdgeBorders = "both";
          border = 0;
        };
        floating = {
          titlebar = false;
          border = 0;
        };
        gaps = {
          smartBorders = "on";
          smartGaps = true;
          inner = 10;
          outer = 0;
        };
        output = {
          "Samsung Electric Company LC27G7xT H4ZR400033" = {
            mode = "2560x1440@244Hz";
            pos = "1920 0";
          };
          "ViewSonic Corporation XG2402 SERIES V4K184902415" = {
            mode = "1920x1080@144Hz";
            pos = "0 360";
          };
        };
      };
    };
  };
}
