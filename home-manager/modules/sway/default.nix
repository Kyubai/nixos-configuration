{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgSway = config.modules.sway;
in {
  options.modules.sway.enable = lib.mkEnableOption "enable sway window manager";
  options.modules.sway.modifier = lib.mkOption {
    default = "Mod4";
  };

  config = lib.mkIf cfgSway.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      # to debug config
      checkConfig = false;
      # extraConfig= (import ./config);
      config = {
        modifier = cfgSway.modifer;
        input = {
          "*" = {
            xkb_layout = "eu";
          };
        };
        terminal = "${pkgs.kitty}/bin/kitty";
        # mkOptionDefault is used so this is merged with default config
        keybindings = lib.mkOptionDefault {
          "${cfgSway.modifer}+semicolon" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        };
        bars = [];
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
        menu = "wofi -S drun -i";
        output = {
          "*" = {
            bg = "$(find /data/media/backgrounds/ -type f | shuf -n 1) fill";
          };
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
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
      extraConfig = ''
        bindsym Mod4+i move workspace to output right
        for_window [shell="xwayland"] title_format "[XWayland] %title"
        exec_always xrandr --output $(xrandr --listactivemonitors  | sed 's, ,/,g' | tail -n +2 | sed 's,2560,3000,g' | sort -t '/' -n -k4 -r | sed 's,.*/,,g' | head -n1) --primary
        bindsym Mod4+p exec --no-startup-id grim -g "$(slurp)" - | wl-copy
        bindsym Mod4+Shift+p exec --no-startup-id grim -g "$(slurp)" ~/$(/usr/bin/date '+%FT%R')screenshot.png
        # bindsym $mod+Shift+p exec --no-startup-id ksnip -p ~/$(/usr/bin/date '+%FT%R')screenshot
        # bindsym Alt+Print exec --no-startup-id wf-recorder -g "$(slurp)" - | wl-copy
        bindsym Shift+Alt+Print exec --no-startup-id wf-recorder -g "$(slurp)" ~/(/usr/bin/date '%FT%R')recording.mp4
      '';
    };

    home.file.".swayinitrc" = {
      source = ./.swayinitrc;
      executable = true;
    };

    programs.wofi.enable = true;
    services.mako.enable = true; # notification
    services.flameshot.enable = true;
  };
}
