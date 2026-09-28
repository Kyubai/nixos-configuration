{
  inputs,
  self,
  ...
}: {
  flake.homeModules.theme = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      catppuccin-kvantum
    ];

    xdg.configFile."Kvantum/kvantum.kvconfig" = {
      force = true;
      text = ''
        [General]
        theme=catppuccin-frappe-blue
      '';
    };

    gtk = {
      enable = true;
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      gtk4.theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 24;
      };
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
