{
  inputs,
  self,
  ...
}: {
  flake.homeModules.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        hostname = {
          ssh_only = false;
          format = "[$hostname]($style) ";
          style = "bold green";
        };
      };
    };
  };
}
