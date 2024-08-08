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

  virtualisation.docker.enable = true;

  programs.ssh.startAgent = true;
  security.sudo.extraConfig = ''
    Defaults>root        env_keep += "SSH_AUTH_SOCK"
    Defaults    timestamp_timeout=-1
  '';

  environment.systemPackages = with pkgs; [
    choose
    corefonts
    dbus
    dig
    htop-vim
    nerdfonts
    nmap
    openssl
    openvpn
    p7zip
    plasma-pa # volume applet
    proxychains
    jq
    unrar
    widevine-cdm
    wireguard-tools
    xsv
  ];
}
