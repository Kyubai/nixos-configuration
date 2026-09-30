{
  inputs,
  ...
}: {
  flake.homeModules.noctalia = {pkgs, ...}: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;
      settings = {
        location = {
          address = "Aachen";
          custom_schedule = true;
          sunrise = "06:30";
          sunset = "22:00";
        };
        theme = {
          source = "builtin";
          builtin = "Tokyo-Night";
        };
        nightlight.enabled = true;
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
        bar.default.start = ["overview" "launcher" "wallpaper" "workspaces"];
        widget.workspaces = {
          style = "focus_hint";
          show_icons = true;
        };
      };
    };
  };
}
