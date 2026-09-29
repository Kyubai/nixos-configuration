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
        wallpaper = {
          directory = "/data/media/backgrounds";
          automation = {
            enabled = true;
            order = "random";
            recursive = true;
            interval_seconds = 1800;
          };
        };
        bar.default.position = "bottom";
        bar.default.scale = 1.5;
        bar.default.thickness = 50;
        bar.default.widget_spacing = 16;
        widget.workspaces = {
          style = "focus_hint";
          show_icons = true;
        };
      };
    };
  };
}
