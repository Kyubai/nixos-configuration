{
  inputs,
  self,
  ...
}: {
  flake.homeModules.ssh = {
    lib,
    pkgs,
    ...
  }: {
    programs.ssh.settings."*".AddKeysToAgent = "yes";
  };
}
