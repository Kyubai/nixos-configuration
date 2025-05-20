{
  config,
  lib,
  ...
}: let
  cfgSteam = config.modules.steam;
in {
  options.modules.steam.enable = lib.mkEnableOption "enable steam desktop file";

  config = lib.mkIf cfgSteam.enable {
    #home.file.".local/share/applications/steam.desktop" = {
    # source = ./steam.desktop;
    #};
  };
}
