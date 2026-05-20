{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.base = {pkgs, ...}: {
    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false; # home-manager config includes custom compinit to run only once a day for new completions
    };
    users.defaultUserShell = pkgs.zsh;

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;
    nixpkgs.config.allowUnfree = true;

    # Perform garbage collection to save disk space
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 4w";
    };
    # Limit the number of generations to keep
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.grub.configurationLimit = 10;

    networking.firewall.enable = true;
    # services.ntp.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    time.timeZone = "Europe/Berlin";
    console.keyMap = "eu";

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

    # required for GTK apps
    programs.dconf.enable = true;

    services.dbus.enable = true;
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

    services.gnome.gnome-keyring.enable = true;
    services.gnome.gcr-ssh-agent.enable = false;

    programs.ssh.startAgent = true; # conflict with gnome agent
    security.sudo.extraConfig = ''
      Defaults>root        env_keep += "SSH_AUTH_SOCK XAUTHORITY DISPLAY"
      Defaults    timestamp_timeout=-1
    '';

    environment.systemPackages = with pkgs; [
      comma
      curl
      dbus
      file
      git
      home-manager
      kdePackages.konsole # fallback terminal
      libsForQt5.qt5ct # might be required for kvantum
      libsForQt5.qtstyleplugin-kvantum # might be required for kvantum https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2
      nix-search-cli
      vim
      wget
      # shared-mime-info # optional, but nice to have
    ];
  };
}
