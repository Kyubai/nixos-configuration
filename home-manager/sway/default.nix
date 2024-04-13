{ ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    extraConfig= (import ./config);
  };

  home.file.".swayinitrc" = {
    source = ./.swayinitrc;
    executable = true;
  };

  programs.wofi.enable = true;
}
