{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.srv-compose = {
    config,
    pkgs,
    ...
  }: {
    virtualisation.docker.enable = true;

    environment.persistence."/persist".directories = [
      "/var/lib/docker"
    ];

    systemd.services.docker-compose-update = {
      description = "Update all Docker Compose services in /srv";
      after = ["network-online.target" "docker.service"];
      wants = ["network-online.target"];
      requires = ["docker.service"];
      script = ''
        for dir in /srv/*/; do
          if [ -f "$dir/docker-compose.yml" ]; then
            ${pkgs.docker}/bin/docker compose -f "$dir/docker-compose.yml" pull --quiet
            ${pkgs.docker}/bin/docker compose -f "$dir/docker-compose.yml" up -d --remove-orphans
          fi
        done
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.timers.docker-compose-update = {
      description = "Daily Docker Compose update timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "05:25:00";
        Persistent = true;
      };
    };

    system.autoUpgrade = {
      enable = true;
      flake = "/etc/nixos#${config.networking.hostName}";
      dates = "04:30";
      allowReboot = true;
    };

    age.secrets.restic-wasabi.file = "${self}/secrets/restic-wasabi.age";

    services.restic.backups.wasabi = {
      repository = "s3:https://s3.eu-central-2.wasabisys.com/restic-verriegelt";
      environmentFile = config.age.secrets.restic-wasabi.path;
      paths = [ "/srv" ];
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
