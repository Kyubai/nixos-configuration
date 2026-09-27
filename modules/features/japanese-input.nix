{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.japanese-input = {
    lib,
    pkgs,
    ...
  }: {
    i18n.inputMethod = {
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-configtool
      ];
      fcitx5.waylandFrontend = true;
    };
  };

  flake.homeModules.japanese-input = {
    lib,
    pkgs,
    ...
  }: {
    # kitty only supports ibus; fcitx provides an ibus interface.
    # QT_IM_MODULE uses fcitx directly since ibus breaks some Qt apps (e.g. mumble).
    home.sessionVariables = {
      GLFW_IM_MODULE = "ibus";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };
}
