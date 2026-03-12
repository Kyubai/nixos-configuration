{
  inputs,
  self,
  ...
}: {
  flake.homeModules.nix-index = {pkgs, ...}: {
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    home.file.".cache/nix-index/files" = {
      source = inputs.nix-index-db.packages.${pkgs.system}.default;
    };
  };
}
