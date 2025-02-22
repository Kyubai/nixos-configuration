{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgTheme = config.modules.theme;
in {
  options.modules.theme.enable = lib.mkEnableOption "enable custom theme";

  config =
    lib.mkIf cfgTheme.enable
    {
      gtk = {
        enable = true;
        theme = {
          name = "Tokyonight-Dark";
          package = pkgs.tokyonight-gtk-theme;
        };
        font = {
          name = "Hack Nerd Font";
          package = pkgs.nerd-fonts.hack;
        };
        cursorTheme = {
          name = "Nordzy-cursors";
          package = pkgs.nordzy-cursor-theme;
          size = 24;
        };
#         iconTheme = {
#           name = "TokyoNight-SE";
#           package = pkgs.tokyo-night-icons;
#         };
      };

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
}
