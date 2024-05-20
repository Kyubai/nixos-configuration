{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # extraConfig= (import ./config);
    config = {
      modifier = "Mod4";
      input = {
        "*" = {
          xkb_layout = "eu";
        };
      };
      terminal = "${pkgs.kitty}/bin/kitty";
      window = {
        titlebar = false;
      };
      floating = {
        titlebar = false;
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
      # bars =  [
      #   {
      #     mode = "hide";
      #     position = "bottom";
      #   }
      # ];
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
      bindsym Mod4+0 workspace number 0
      bindsym Mod4+Shift+0 move container to workspace number 0
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
  services.mako.enable = true;
}