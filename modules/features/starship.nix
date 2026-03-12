{
  inputs,
  self,
  ...
}: {
  flake.homeModules.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
