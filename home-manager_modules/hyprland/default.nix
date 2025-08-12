{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "enable hyprland window manager";
    laptop.enable = lib.mkEnableOption "enable additional options and modules for laptops";
    terminal = lib.mkOption {
      default = "kitty";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.dunst.enable = true; # notification deamon
    programs.wofi.enable = true; # dmenu
    modules.kitty.enable = true;
    modules.waybar.enable = true;

    modules.waybar.laptop = lib.mkIf cfg.laptop.enable {enable = true;};

    home.pointerCursor = {
      hyprcursor.enable = true;
      package = pkgs.nordzy-cursor-theme; # cursor theme
      name = "Nordzy-hyprcursors";
    };

    # wallpaper deamon settings
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
      };
    };

    # lock screen
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            outline_thickness = 5;
            placeholder_text = "Password";
            shadow_passes = 2;
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        monitor = DP-1, 1920x1080, 0x180, 1
        monitor = DP-3, 2560x1440, 1920x0, 1

        # applications for wayland
        exec-once = hyprpaper
        exec-once = sleep 1 && hyprctl hyprpaper reload , $(find /data/media/backgrounds -type f | shuf -n 1)
        exec-once = waybar
        exec-once = hyprctl setcursor Nordzy-hyprcursors 24
        # fix screen cast portal not being available
        # https://wiki.hyprland.org/Hypr-Ecosystem/xdg-desktop-portal-hyprland/#usage
        exec-once = sleep 5 && xdg-desktop-portal-hyprland.service && sleep 5 && systemctl --user restart xdg-desktop-portal.service

        # autostart user applications
        exec-once = [workspace 0 silent] ${cfg.terminal}
        exec-once = [workspace 2 silent] vivaldi
        exec-once = [workspace 5 silent] flatpak run dev.vencord.Vesktop
        exec-once = [workspace 6 silent] feishin
        exec-once = [workspace 9 silent] steam

        # https://wiki.hyprland.org/Configuring/Workspace-Rules/#smart-gaps
        workspace = w[tv1], gapsout:0, gapsin:0
        workspace = f[1], gapsout:0, gapsin:0
        windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
        windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
        windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
        windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

        # open windows on specific workspace
        windowrulev2 = workspace 2 silent, class:^(vivaldi-stable)$
        windowrulev2 = workspace 4 silent, class:^(anki)$
        windowrulev2 = workspace 5 silent, class:^(vesktop)$
        windowrulev2 = workspace 6 silent, class:^(feishin)$
        windowrulev2 = workspace 9 silent, class:^(steam)$

        # https://wiki.hyprland.org/Configuring/Environment-variables/
        # Toolkit Backed stuff
        env = GDK_BACKEND,wayland,x11,*
        # env = SDL_VIDEODRIVER,wayland # disabled for now, as this causes issues
        env = CLUTTER_BACKEND,wayland
        env = GTK_USE_PORTAL,1
        # XDG stuff
        env = XDG_CURRENT_DESKTOP,Hyprland
        env = XDG_SESSION_DESKTOP,Hyprland
        env = XDG_SESSION_TYPE,wayland
        # QT stuff
        env = QT_AUTO_SCREEN_SCALE_FACTOR,1
        env = QT_QPA_PLATFORM,wayland;xcb
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
        env = QT_QPA_PLATFORMTHEME,qt5ct # should already be set in theme module
        # Application stuff
        env = NIXOS_OZONE_WL,1
        env = MOZ_ENABLE_WAYLAND,1
        env = XDG_MENU_PREFIX,plasma-

        env = WLR_NO_HARDWARE_CURSORS,1
        env = WLR_RENDERER_ALLOW_SOFTWARE,1
        env = _JAVA_AWT_WM_NONREPARENTING,1
        env = NIXOS_XDG_OPEN_USE_PORTAL,1
      '';

      # enableNvidiaPatches = true;
      xwayland.enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "${cfg.terminal}";
        "$menu" = "wofi -S drun -i";
        "$fileManager" = "dolphin";
        # debug = {
        # disable_logs = false;
        # };
        misc = {
          focus_on_activate = false;
        };
        gestures = {
          workspace_swipe = false;
        };
        input = {
          kb_layout = "eu";
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        animations = {
          enabled = false;
        };
        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, code:47, exec, $terminal" # code:47 is semicolon
          "$mod, e, exec, $fileManager"
          "$mod, d, exec, $menu"
          "$mod, code:65, togglefloating," # code:65 is space
          "$mod, n, pseudo," # dwindle
          "$mod, m, togglesplit," # dwindle
          "$mod, o, exec, hyprlock --immediate --no-fade-in"
          "$mod, c, killactive"
          # "$mod SHIFT, C, forcekillactive" # doesn't work for some reason
          "$mod, v, exec, pulsemixer"
          "$mod, p, exec, grimblast --freeze save area - | swappy -f - -o - | wl-copy"
          "$mod SHIFT, p, exec, grimblast --freeze save area - | swappy -f - -o ~/screenshots/$(date -Iseconds)_screenshot.png"
          "$mod CTRL, p, exec, wl-screenrec -g \"$(slurp)\" -f ~/recordings/$(date -Iseconds)_recording.mp4"

          # Move focus with mainMod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod, f, fullscreen"

          # Switch workspaces with mainMod + [0-9]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          "$mod, I, movecurrentworkspacetomonitor,+1"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
