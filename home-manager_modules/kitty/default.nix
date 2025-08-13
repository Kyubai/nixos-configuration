{
  config,
  lib,
  ...
}: let
  cfgKitty = config.modules.kitty;
in {
  options.modules.kitty.enable = lib.mkEnableOption "kitty terminal emulator";

  config = lib.mkIf cfgKitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "0.5";
        enable_audio_bell = false;
        draw_minimal_border = true;
        disable_ligatures = "always";
        update_check_interval = 0;
        term = "kitty";
      };
      themeFile = "tokyo_night_night";
      keybindings = {
        "ctrl+c" = "copy_to_clipboard";
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+shift+c" = "send_text all \\x03"; # SIGINT
        "ctrl+shift+v" = "send_text all \\x16"; # Pastchar
      };
    };

    home.sessionVariables = {
      TERM = "kitty";
    };
  };
}
