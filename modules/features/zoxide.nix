{
  inputs,
  self,
  ...
}: {
  flake.homeModules.zoxide = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    home.shellAliases = {
      cd = "z";
    };
  };
}
