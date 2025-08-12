{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfgBase = config.modules.base;
  # nixpkgs-unstable.config.allowUnfree = true;
  # unstablePkgs = import nixpkgs-unstable {
  # };
in {
  options.modules.base.enable = lib.mkEnableOption "base nix config";

  config = lib.mkIf cfgBase.enable {
    # TODO: move this to home-manager
    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false; # home-manager config includes custom compinit to run only once a day for new completions
    };
    users.defaultUserShell = pkgs.zsh;

    # disabled as package is broken atm. 2024-12-31
    # boot.supportedFilesystems = ["zfs"];
    # boot.zfs.forceImportRoot = false;
    # nixpkgs.config.allowBroken = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;
    nixpkgs.config.allowUnfree = true;
    system.autoUpgrade.enable = true;
    # Perform garbage collection to save disk space
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5w";
    };
    # Limit the number of generations to keep
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.grub.configurationLimit = 10;

    # services.ntp.enable = true;

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    time.timeZone = "Europe/Berlin";
    console.keyMap = "us";
    services.xserver.xkb.layout = "eu";

    fonts.packages = [
      pkgs.nerd-fonts.hack
      pkgs.noto-fonts-cjk-sans
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
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # extraPortals = with pkgs; [
      # xdg-desktop-portal-gtk
      # kdePackages.xdg-desktop-portal-kde # for file-picker
      # ];
    };
    xdg.menus.enable = true;

    programs.ssh.startAgent = true;
    security.sudo.extraConfig = ''
      Defaults>root        env_keep += "SSH_AUTH_SOCK XAUTHORITY DISPLAY"
      Defaults    timestamp_timeout=-1
    '';

    environment.systemPackages = with pkgs; [
      dbus
      file
      home-manager
      kdePackages.konsole # fallback terminal
      libsForQt5.qtstyleplugin-kvantum # might be required for kvantum https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2
      libsForQt5.qt5ct # might be required for kvantum
      nix-search-cli
      # lxqt.lxqt-menu-data
      # shared-mime-info # optional, but nice to have
    ];
  };
}
