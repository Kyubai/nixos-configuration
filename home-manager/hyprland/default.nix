{ ... }:
{
  imports = [
    ../kitty
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    xwayland.enable = true;
    extraConfig = (import ./hyprland.conf);
  };
  # home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  home.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";
  home.sessionVariables.XDG_CURRENT_DESKTOP= "Hyprland";
  home.sessionVariables.XDG_SESSION_DESKTOP= "Hyprland";
  home.sessionVariables.XDG_SESSION_TYPE= "wayland";
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING= "1";
  

  home.file.".hyprlandinitrc" = {
    source = ./.hyprlandinitrc;
    executable = true;
  };
}
