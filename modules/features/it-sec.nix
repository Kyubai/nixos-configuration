{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.it-sec = {
    pkgs,
    nixpkgs-unstable,
    ...
  }: let
    unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config = pkgs.config;
    };

    angle-grinder-override = unstable.angle-grinder.overrideAttrs (_: {
      version = "unstable";

      src = unstable.fetchFromGitHub {
        owner = "rcoh";
        repo = "angle-grinder";
        rev = "9c2fc8846d7e950160579ef0b2d7ca56a76688e9";
        hash = "sha256-V4tNilfzHey/Kg9tUsuWlKd0sxNBj+uvb2u4kLN8ZWI=";
      };

      cargoHash = unstable.lib.fakeHash;
    });
  in {
    environment.systemPackages = with pkgs; [
      angle-grinder-override
      bintools
      flawz # tui cve
      fq # jq for binary
      imhex
      jless # less for json
      lnav
      nmap
      openfortivpn
      sqlite
      sshfs
      sshpass
      teamviewer
      vmfs-tools
    ];
    security.krb5.enable = true;
    services.teamviewer.enable = true;
    # security.krb5.settings.include = "/current_customer/.config/krb5.conf";
  };
}
