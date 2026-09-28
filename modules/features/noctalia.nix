{
  inputs,
  ...
}: {
  flake.homeModules.noctalia = {pkgs, ...}: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;
      settings = {
        location.address = "Aachen";
        bar.default.position = "bottom";
        accessibility.ui_scale = 1.5;
      };
    };
  };
}
