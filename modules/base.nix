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

  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    choose
    corefonts
    dbus
    docker
    htop-vim
    nerdfonts
    openvpn
    p7zip
    plasma-pa # volume applet
    proxychains
    unrar
    widevine-cdm
    xsv
  ];
}
