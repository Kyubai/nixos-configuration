{
  config,
  lib,
  ...
}: let
  cfgDocker = config.modules.docker;
in {
  options.modules.docker.enable = lib.mkEnableOption "docker aliases";

  config = lib.mkIf cfgDocker.enable {
    home.shellAliases = {
      dcud = "sudo docker compose up -d";
      dcd = "sudo docker compose down";
      dcr = "sudo docker compose down && sudo docker compose up -d";
      dcl = "sudo docker compose logs";
    };
  };
}
