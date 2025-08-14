{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgXorg = config.modules.notebook;
in {
  options.modules.notebook.enable = mkEnableOption "notebook config";

  config = mkIf cfgXorg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    # sound.mediaKeys.enable = true;

    # programs.light.brightnessKeys.enable = true;
    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [224];
          events = ["key"];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set '5%-'";
        }
        {
          keys = [225];
          events = ["key"];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set '5%+'";
        }
      ];
    };
  };
}
