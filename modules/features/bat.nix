{
  inputs,
  self,
  ...
}: {
  flake.homeModules.bat = {
    programs.bat.enable = true;
    home.shellAliases = {
      cat = "bat -p";
    };
  };
}
