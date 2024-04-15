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
      # bars =  [
      #   {
      #     mode = "hide";
      #     position = "bottom";
      #   }
      # ];
    };
  };

  # xdg.configFile.".config/sway/config".source = pkgs.lib.mkOverride 0 ./config;

  home.file.".swayinitrc" = {
    source = ./.swayinitrc;
    executable = true;
  };

  programs.wofi.enable = true;
}
