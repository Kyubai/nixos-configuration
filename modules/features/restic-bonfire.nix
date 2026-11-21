{
  self,
  ...
}: {
  flake.nixosModules.restic-bonfire = {config, ...}: {
    age.secrets.restic-bonfire.file = "${self}/secrets/restic-bonfire.age";

    services.restic.backups.bonfire = {
      repository = "s3:https://s3.eu-central-2.wasabisys.com/restic-fluxer-contabo";
      environmentFile = config.age.secrets.restic-bonfire.path;
      paths = ["/srv"];
      timerConfig = {
        OnCalendar = "05:45:00";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
      ];
    };
  };
}
