{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.impermanence = {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        {
          directory = "/etc/nixos";
          method = "symlink";
        }
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/log"
        "/srv"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
