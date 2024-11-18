{ config, lib, ... }:

  let cfgSsh = config.modules.ssh;
  in {
    options.modules.ssh.enable = lib.mkEnableOption "enable ssh config";

    config = lib.mkIf cfgSsh.enable {
  programs.ssh.addKeysToAgent = "yes";
};}
