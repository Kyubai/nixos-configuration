{ pkgs, ... }:
{
  wayland.windowManager.sway.config.bars = [
    {
      command = "${pkgs.waybar}/bin/waybar";
    }
  ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "bottom";
        height = 30;
      };
    };
  };
}
