{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.srv-compose = {
    config,
    ...
  }: {
    virtualisation.docker.enable = true;

    environment.persistence."/persist".directories = [
      "/var/lib/docker"
    ];

    age.secrets.restic-wasabi.file = "${self}/secrets/restic-wasabi.age";

    services.restic.backups.wasabi = {
      repository = "s3:https://s3.eu-central-2.wasabisys.com/restic-verriegelt";
      environmentFile = config.age.secrets.restic-wasabi.path;
      dynamicFilesFrom = "cat /srv/restic/include.txt";
      extraBackupArgs = [
        "--exclude-file=/srv/restic/exclude.txt"
        "--host=${config.networking.hostName}"
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
