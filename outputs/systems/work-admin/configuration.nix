# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # my own /etc/nixos/modules
  modules.base.enable = true;
  modules.cli.utils.enable = true;
  modules.sec.utils.enable = true;
  modules.desktop.tools.enable = true;
  # modules.desktop.hyprland.enable = true;
  modules.desktop.xorg.enable = true;
  modules.vm.vmware.guest.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  system.autoUpgrade.enable = true;

  # required for zfs support
  networking.hostId = "621cba57";

  nixpkgs.config.allowUnfree = true;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "work-admin";

  fileSystems."/data/tools/at-yet" = {
    device = ".host:/data_tools";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  fileSystems."/data/tools/personal" = {
    device = ".host:/data_personal";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  fileSystems."/data/at-yet" = {
    device = ".host:/data_work";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  fileSystems."/data/share" = {
    device = ".host:/share";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  fileSystems."/data/obsidian_vaults" = {
    device = ".host:/obsidian_vaults";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #   fonts.fontconfig.defaultFonts.serif = [
  #     "Hack Nerd Font"
  #   ];
  #
  #   fonts.fontconfig.defaultFonts.sansSerif = [
  #     "Hack Nerd Font"
  #   ];
  #
  #   fonts.fontconfig.defaultFonts.monospace = [
  #     "Hack Nerd Font Mono"
  #   ];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.dbus.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "eu";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mri = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
}
