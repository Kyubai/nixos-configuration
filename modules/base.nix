{ pkgs, ... }:
{

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
    nerdfonts
    p7zip
    plasma-pa # volume applet
    xsv
    choose
    unrar
    widevine-cdm
  ];
}
