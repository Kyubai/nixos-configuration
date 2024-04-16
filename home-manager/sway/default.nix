{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # extraConfig= (import ./config);
    config = {
      modifier = "Mod4";
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
  };

  home.file.".swayinitrc" = {
    source = ./.swayinitrc;
    executable = true;
  };

  programs.wofi.enable = true;
  services.mako.enable = true;
}
