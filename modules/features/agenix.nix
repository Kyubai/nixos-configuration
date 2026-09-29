{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.agenix = {pkgs, ...}: {
    imports = [inputs.agenix.nixosModules.default];
    environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.system}.default];
  };
}
