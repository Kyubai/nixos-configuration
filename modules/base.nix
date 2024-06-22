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

  # any programs in "users" group can request real-time priority
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  environment.systemPackages = with pkgs; [
    corefonts
    dbus
    htop-vim
    p7zip
    # pavucontrol
    # plasma-pa # volume applet
    wl-clipboard
    wdisplays
    xsv
    choose
    ripgrep
    unrar
  ];
}
