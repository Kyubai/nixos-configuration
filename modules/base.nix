{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgBase = config.modules.base;
in {
  options.modules.base.enable = mkEnableOption "base nix config";

  config = mkIf cfgBase.enable {
    # TODO: move this to home-manager
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;
    nixpkgs.config.allowUnfree = true;
    # Perform garbage collection to save disk space
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5w";
    };
    # Limit the number of generations to keep
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.grub.configurationLimit = 10;

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    time.timeZone = "Europe/Berlin";
    console.keyMap = "us";

    fonts.packages = with pkgs; [
      nerdfonts
    ];

    fonts.fontconfig.defaultFonts.serif = [
      "Hack Nerd Font"
    ];

    fonts.fontconfig.defaultFonts.sansSerif = [
      "Hack Nerd Font"
    ];

    fonts.fontconfig.defaultFonts.monospace = [
      "Hack Nerd Font Mono"
    ];

    services.gnome.gnome-keyring.enable = true;
    # required for GTK apps
    programs.dconf.enable = true;

    # doesn't seem to work with Vivaldi yet
    # programs.chromium.extensions = [
    #   "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    # ];

    security.polkit.enable = true;
    security.rtkit.enable = true;

    # any programs in "users" group can request real-time priority
    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];

    services.dbus.enable = true;
    xdg.portal.enable = true;
    xdg.autostart.enable = true;
    xdg.portal.config.common.default = "*";

    programs.ssh.startAgent = true;
    security.sudo.extraConfig = ''
      Defaults>root        env_keep += "SSH_AUTH_SOCK"
      Defaults    timestamp_timeout=-1
    '';

    environment.systemPackages = with pkgs; [
      dbus
    ];
  };
}
