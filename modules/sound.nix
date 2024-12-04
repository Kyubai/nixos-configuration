{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgSound = config.modules.desktop.sound;
in {
  options.modules.desktop.sound.enable = mkEnableOption "sound";
  config = mkIf cfgSound.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
