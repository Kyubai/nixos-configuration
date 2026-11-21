{
  self,
  ...
}: {
  flake.nixosModules.restic-verriegelt = {config, ...}: {
    age.secrets.restic-verriegelt.file = "${self}/secrets/restic-verriegelt.age";

    services.restic.backups.verriegelt = {
      repository = "s3:https://s3.eu-central-2.wasabisys.com/restic-verriegelt";
      environmentFile = config.age.secrets.restic-verriegelt.path;
      paths = ["/srv"];
      exclude = ["*.bak"];
      timerConfig = {
        OnCalendar = "05:00:00";
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
