{
  config,
  lib,
  ...
}: let
  cfgEza = config.modules.eza;
in {
  options.modules.eza.enable = lib.mkEnableOption "enable eza as ls alternative";

  config =
    lib.mkIf cfgEza.enable
    {
      programs.eza.enable = true;
      home.shellAliases = {
        ls = "eza --time-style long-iso";
        la = "eza -a";
        ll = "eza -l --time-style long-iso";
        lh = "eza -lh --time-style long-iso";
        lla = "eza -la --time-style long-iso";
        lha = "eza -lha --time-style long-iso";
      };
    };
}
