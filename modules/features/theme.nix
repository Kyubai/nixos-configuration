{
  inputs,
  self,
  ...
}:
let
  # Full Catppuccin Frappé color palette sections, shared between the
  # .colors scheme file (read by KColorScheme) and kdeglobals.
  # BackgroundAlternate = BackgroundNormal to remove alternating row colors.
  catppuccinFrappeColors = ''
    [ColorEffects:Disabled]
    ChangeHue=0
    ChangeSaturation=1
    ChangeValue=1
    Color=56,56,56
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2
    SaturationAmount=-0.9659999608993530273
    SaturationEffect=2

    [ColorEffects:Inactive]
    ChangeHue=0
    ChangeSaturation=0
    ChangeValue=0
    Color=112,111,110
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.2
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0
    SaturationAmount=-0.5
    SaturationEffect=1

    [Colors:Button]
    BackgroundAlternate=81,87,109
    BackgroundNormal=65,69,89
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=140,170,238
    ForegroundInactive=165,173,206
    ForegroundLink=129,200,190
    ForegroundNegative=231,130,132
    ForegroundNeutral=229,200,144
    ForegroundNormal=198,208,245
    ForegroundPositive=166,209,137
    ForegroundVisited=186,187,241

    [Colors:Complementary]
    BackgroundAlternate=65,69,89
    BackgroundNormal=41,44,60
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=140,170,238
    ForegroundInactive=165,173,206
    ForegroundLink=129,200,190
    ForegroundNegative=231,130,132
    ForegroundNeutral=229,200,144
    ForegroundNormal=198,208,245
    ForegroundPositive=166,209,137
    ForegroundVisited=186,187,241

    [Colors:Header]
    BackgroundAlternate=41,44,60
    BackgroundNormal=35,38,52
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=140,170,238
    ForegroundInactive=165,173,206
    ForegroundLink=129,200,190
    ForegroundNegative=231,130,132
    ForegroundNeutral=229,200,144
    ForegroundNormal=198,208,245
    ForegroundPositive=166,209,137
    ForegroundVisited=186,187,241

    [Colors:Selection]
    BackgroundAlternate=98,104,128
    BackgroundNormal=140,170,238
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=48,52,70
    ForegroundInactive=48,52,70
    ForegroundLink=48,52,70
    ForegroundNegative=48,52,70
    ForegroundNeutral=48,52,70
    ForegroundNormal=48,52,70
    ForegroundPositive=48,52,70
    ForegroundVisited=48,52,70

    [Colors:Tooltip]
    BackgroundAlternate=65,69,89
    BackgroundNormal=81,87,109
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=140,170,238
    ForegroundInactive=165,173,206
    ForegroundLink=129,200,190
    ForegroundNegative=231,130,132
    ForegroundNeutral=229,200,144
    ForegroundNormal=198,208,245
    ForegroundPositive=166,209,137
    ForegroundVisited=186,187,241

    [Colors:View]
    BackgroundAlternate=48,52,70
    BackgroundNormal=48,52,70
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=140,170,238
    ForegroundInactive=165,173,206
    ForegroundLink=129,200,190
    ForegroundNegative=231,130,132
    ForegroundNeutral=229,200,144
    ForegroundNormal=198,208,245
    ForegroundPositive=166,209,137
    ForegroundVisited=186,187,241

    [Colors:Window]
    BackgroundAlternate=65,69,89
    BackgroundNormal=41,44,60
    DecorationFocus=140,170,238
    DecorationHover=186,187,241
    ForegroundActive=140,170,238
    ForegroundInactive=165,173,206
    ForegroundLink=129,200,190
    ForegroundNegative=231,130,132
    ForegroundNeutral=229,200,144
    ForegroundNormal=198,208,245
    ForegroundPositive=166,209,137
    ForegroundVisited=186,187,241
  '';
in
{
  flake.homeModules.theme = {
    lib,
    pkgs,
    ...
  }: {
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

    xdg.dataFile."color-schemes/CatppuccinFrappe.colors".text = catppuccinFrappeColors + ''

      [General]
      ColorScheme=CatppuccinFrappe
      Name=Catppuccin Frappé
      shadeSortColumn=true

      [KDE]
      contrast=4
    '';

    xdg.configFile."kdeglobals" = {
      force = true;
      text = catppuccinFrappeColors + ''

        [General]
        ColorScheme=CatppuccinFrappe
        shadeSortColumn=true

        [Icons]
        Theme=Papirus-Dark

        [KDE]
        contrast=4
      '';
    };

    qt = {
      enable = true;
      style.name = "breeze";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
