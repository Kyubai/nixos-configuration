# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports = [ 
      ./hardware-configuration.nix
      ../../modules/amd.nix
      ../../modules/base.nix
      ../../modules/bluetooth.nix
      ../../modules/desktop.nix
      ../../modules/steam.nix
      ../../modules/sway.nix
      # ../../modules/xorg.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "video=DP-3:1920x1080@144"
    "video=DP-1:2560x1440@240"
  ];
  boot.kernel.sysctl."vm.max_map_count" = "2147483642";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "deack-pc-01";

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

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    brave
    corefonts
    dbus
    discord
    htop-vim
    keepassxc
    (lutris.override {
      extraLibraries = pkgs: [
      ];
      extraPkgs = pkgs: [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    })
    mangohud
    obsidian
    p7zip
    pavucontrol
    plasma-pa
    runelite
    syncthing
    vesktop
    vulkan-tools
    widevine-cdm
    # 32- and 64-bit
    # (wineWowPackages.waylandFull.override {
    #     mingwSupport = false;
    #   })
    # was using .full before
    (wineWowPackages.stable.override {
        # mingwSupport = false;
      })
      winetricks
    ];

  # for obsidian on 2024-04-16
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];
  
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  xdg.autostart.enable = true;
  xdg.portal.config.common.default = "*";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.syncthing = {
    enable = true;
    user = "mri";
    dataDir = "/srv/syncthing";
  };

  # programs.ssh.startAgent = true;
  # fix dynamically linked libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add missing dynamic libraries
    libglvnd
    libGL
    zlib
  ];

  # required for GTK apps
  programs.dconf.enable = true;

  # doesn't seem to work with Vivaldi yet
  # programs.chromium.extensions = [ 
  #   "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  # ];

  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mri = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "gamemode"
    ]; 
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
}

