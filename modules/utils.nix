{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgUtils = config.modules.cli.utils;
in {
  options.modules.cli.utils.enable = mkEnableOption "basic cli utils";
  config = mkIf cfgUtils.enable {
    programs.zsh = {
      enable = true;
    };

    users.defaultUserShell = pkgs.zsh;

    # any programs in "users" group can request real-time priority
    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];

    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      choose
      dbus
      dig
      expect # for unbuffer command
      htop-vim
      netdiscover
      nmap
      openssl
      openvpn
      p7zip
      plasma-pa # volume applet
      proxychains
      jq
      unixtools.xxd
      unrar
      tcpdump
      vim
      widevine-cdm
      wineWowPackages.stable
      wireguard-tools
      xsv
    ];

    # make update-resolv-conf script available to update dns server on openvpn connect
    # https://github.com/NixOS/nixpkgs/issues/73822
    environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
  };
}
