{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.ashell;
  unstableHomeManagerModule = import inputs.home-manager-unstable {
    pkgs = inputs.nixpkgs-unstable;
  };
in {
  imports = [
    unstableHomeManagerModule
  ];
  options.modules.waybar = {
    enable = lib.mkEnableOption "enable ashell statusbar";
    laptop.enable = lib.mkEnableOption "enable laptop config";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway.config.bars = [
      {
        command = "${pkgs.ashell}/bin/ashell";
      }
    ];

    programs.ashell = {
      enable = true;
    };
  };
}
