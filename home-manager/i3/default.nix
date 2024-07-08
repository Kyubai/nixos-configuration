{ lib, config, pkgs, ... }:
let
  modifier = "Mod4";
in
{
  # home.file.".config/i3/config".source = ./config;
  xsession.windowManager.i3 = {
    enable = true;
    # wrapperFeatures.gtk = true;
    # extraConfig= (import ./config);
    config = {
      modifier = "${modifier}";
      terminal = "${pkgs.kitty}/bin/kitty";
      keybindings = lib.mkOptionDefault {
        "${modifier}+k" = "exec ${config.i3.windowManager.sway.config.terminal}";
      };
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      floating = {
        titlebar = false;
      };
    };
  };

  home.file.".xinitrc" = {
    text = ''
    exec i3
    '';
  };
}
