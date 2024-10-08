# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    #     ../../../modules/base.nix
    #     ../../../modules/vmware-guest.nix
    # ../../../modules/xorg.nix
  ];

  modules.base.enable = true;
  modules.vmware.guest.enable = true;
  modules.desktop.xorg.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "nixos-test-virtmanager";

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts.fontconfig.defaultFonts.serif = [
    "Hack Nerd Font"
  ];

  fonts.fontconfig.defaultFonts.sansSerif = [
    "Hack Nerd Font"
  ];

  fonts.fontconfig.defaultFonts.monospace = [
    "Hack Nerd Font Mono"
  ];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  environment.systemPackages = with pkgs; [
    dbus
    discord
    spice-vdagent
    vivaldi
    vivaldi-ffmpeg-codecs
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  xdg.autostart.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  services.openssh = {
    enable = true;
  };

  programs.ssh.startAgent = true;

  # doesn't seem to work with Vivaldi yet
  programs.chromium.extensions = [
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  ];

  security.polkit.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mri = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    #   packages = with pkgs; [
    #     firefox
    #     tree
    #   ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
