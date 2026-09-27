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
    programs.ssh.addKeysToAgent = "yes";
  };
}
