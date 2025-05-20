{
  config,
  lib,
  ...
}: let
  cfg = config.modules.alacritty;
in {
  options.modules.alacritty.enable = lib.mkEnableOption "alacritty terminal emulator";

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.LIBGL_ALWAYS_SOFTWARE = "1";
      };
    };
  };
}
