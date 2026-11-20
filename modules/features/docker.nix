{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.docker = {
    virtualisation.docker.daemon.settings = {
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };

    virtualisation.docker.autoPrune = {
      enable = true;
      flags = ["--all"];
      dates = "weekly";
      allVolumes.enable = true;
    };
  };

  flake.homeModules.docker = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = [ pkgs.docker-compose ];

    home.shellAliases = {
      dcud = "sudo docker compose up -d";
      dcd = "sudo docker compose down";
      dcr = "sudo docker compose down && sudo docker compose up -d";
      dcl = "sudo docker compose logs";
    };
  };
}
