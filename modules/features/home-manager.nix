{
  inputs,
  self,
  ...
}: {
  imports = [inputs.home-manager.flakeModules.home-manager];
  flake.modules.nixos.home-manager = {
    verbose = true;
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    backupCommand = "rm";
    overwriteBackup = true;
  };

  flake.homeModules.home-manager = {
    home.shellAliases = {
      hms = "pushd /etc/nixos && home-manager switch --extra-experimental-features \"nix-command flakes\" --flake .#$USER && popd";
    };
  };
}
