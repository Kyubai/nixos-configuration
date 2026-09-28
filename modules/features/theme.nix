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

    # Override respect_DE so Kvantum uses its own GeneralColors instead of
    # inheriting from the platform theme (which may provide Breeze Light palette).
    # Both kvconfig and svg must be present in the user override dir or Kvantum
    # fails to find the svg and falls back to a broken style.
    xdg.configFile."Kvantum/catppuccin-frappe-blue/catppuccin-frappe-blue.kvconfig".text =
      builtins.replaceStrings
        ["respect_DE=true"]
        ["respect_DE=false"]
        (builtins.readFile "${pkgs.catppuccin-kvantum}/share/Kvantum/catppuccin-frappe-blue/catppuccin-frappe-blue.kvconfig");
    xdg.configFile."Kvantum/catppuccin-frappe-blue/catppuccin-frappe-blue.svg".source =
      "${pkgs.catppuccin-kvantum}/share/Kvantum/catppuccin-frappe-blue/catppuccin-frappe-blue.svg";

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
      iconTheme = {
        name = "Papirus-Dark";
        # installed as system package in niri.nix to avoid profile merge issues
      };
      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 24;
      };
    };

    # Catppuccin Frappé color scheme for KDE/Qt apps (Dolphin etc.)
    xdg.configFile."kdeglobals" = {
      force = true;
      text = ''
        [Icons]
        Theme=Papirus-Dark

        [Colors:View]
        BackgroundNormal=48,52,70
        BackgroundAlternate=48,52,70
        ForegroundNormal=198,208,245
        ForegroundInactive=165,173,206

        [Colors:Window]
        BackgroundNormal=41,44,60
        ForegroundNormal=198,208,245

        [Colors:Button]
        BackgroundNormal=65,69,89
        ForegroundNormal=198,208,245

        [Colors:Selection]
        BackgroundNormal=140,170,238
        ForegroundNormal=48,52,70

        [Colors:Tooltip]
        BackgroundNormal=81,87,109
        ForegroundNormal=198,208,245
      '';
    };

    qt = {
      enable = true;
      style.name = "kvantum";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
