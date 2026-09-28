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
        bar.default.scale = 1.5;
        bar.default.thickness = 50;
        widget.workspaces = {
          style = "focus_hint";
          show_icons = true;
        };
      };
    };
  };
}
