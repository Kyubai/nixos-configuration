{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  programs.git.config = {
    init = {
      defaultBranch = "main";
    };
    user = {
      email = "public@verriegelt.net";
      name = "Matthias Riegel";
    };
    pull = {
      ff = "only";
    };
    safe = {
      directory = "/etc/nixos";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  # wayland.windowManager.sway = {
  #   config = {
  #     bars = [{
  #       fonts.size = 15.0;
  #       # command = "waybar"; You can change it if you want
  #       position = "bottom";
  #     }];
  #   };
  # };

}
