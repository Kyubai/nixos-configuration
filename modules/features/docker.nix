{
  inputs,
  self,
  ...
}: {
  flake.homeModules.docker = {
    lib,
    pkgs,
    ...
  }: {
    home.shellAliases = {
      dcud = "sudo docker compose up -d";
      dcd = "sudo docker compose down";
      dcr = "sudo docker compose down && sudo docker compose up -d";
      dcl = "sudo docker compose logs";
    };
  };
}
