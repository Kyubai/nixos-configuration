{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.srv-compose = {
    ...
  }: {
    virtualisation.docker.enable = true;

    environment.persistence."/persist".directories = [
      "/var/lib/docker"
    ];
  };
}
