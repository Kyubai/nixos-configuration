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
}
