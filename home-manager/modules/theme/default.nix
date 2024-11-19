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
          name = "Adwaita-dark";
          package = pkgs.gnome.gnome-themes-extra;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "qt5ct";
        style.name = "kvantum";
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
}
