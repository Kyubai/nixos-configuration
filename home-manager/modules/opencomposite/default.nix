{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.opencomposite;
in {
  options.modules.opencomposite.enable = lib.mkEnableOption "enable opencomposite config";
  config = lib.mkIf cfg.enable {
    # For Monado:
    # xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";

    # For WiVRn:
    xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";

    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "${config.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite}/lib/opencomposite"
        ],
        "version" : 1
      }
    '';
  };
}
