{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.nas = {pkgs, ...}: {
    age.secrets.nas-credentials.file = self + "/secrets/nas-credentials.age";
    environment.systemPackages = [pkgs.cifs-utils];
  };

  flake.homeModules.nas = {...}: {
    home.file."scripts/mount-nas.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        sudo mount -t cifs //deack-nas-01.intern.verriegelt.net/media \
          -o credentials=/run/agenix/nas-credentials,uid=$(id -u),gid=$(id -g) \
          /mnt/media
      '';
    };
  };
}
