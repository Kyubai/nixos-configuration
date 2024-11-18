{
  lib,
  config,
  pkgs,
  ...
}: let
  cfgI3 = config.modules.i3;
in {
  options.modules.i3.enable = lib.mkEnableOption "enable i3 window manager";
  options.modules.i3.modifier = lib.mkOption {
    default = "Mod4";
  };

  config = lib.mkIf cfgI3.enable {
    modules.kitty.enable = true; # kitty is used as terminal emulator

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = cfgI3.modifier;
        terminal = "${pkgs.kitty}/bin/kitty";
        keybindings = lib.mkOptionDefault {
          "${cfgI3.modifier}+semicolon" = "exec ${config.xsession.windowManager.i3.config.terminal}"; # 47 is Semicolon
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
  };
}
