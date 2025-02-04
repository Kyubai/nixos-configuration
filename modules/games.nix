{
  config,
  inputs,
  lib,
  nixpkgs-stable,
  pkgs,
  ...
}:
with lib; let
  cfgGaming = config.modules.desktop.gaming;
  pkgs-stable = import nixpkgs-stable {
    config.allowUnfree = true;
  };
  inherit (pkgs.stdenv.hostPlatform) system;
  umu-launcher = inputs.umu.packages.${system}.default;
in {
  options.modules.desktop.gaming.enable = mkEnableOption "wine steam and other gaming-related things";

  config = mkIf cfgGaming.enable {
    environment.systemPackages = with pkgs; [
      gamescope
      (lutris.override {
        extraLibraries = pkgs: [
        ];
        extraPkgs = pkgs: [
          keyutils
          libpng
          libpulseaudio
          libvorbis
          libkrb5
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
        ];
      })
      prismlauncher # minecraft client
      mangohud
      runelite
      steamtinkerlaunch
      (wineWowPackages.stable.override {
        # mingwSupport = false;
      })
      umu-launcher
      winetricks
    ];

    # support for controllers
    hardware.steam-hardware.enable = true;

    programs.gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = "0";
    };

    programs.steam = {
      enable = true;
      # package = pkgs-stable.steam;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    # this softlinks my clips dir into the steam_recording tmpfs to make clips persistent
    systemd.user.services.steam_recording_softlink = {
      description = "this services creates a softlink, which is located in a ramdisk, where my steam-recording feature is located. This makes the clips persistent";
      script = ''
        rmdir --ignore-fail-on-non-empty ~/.steam_recording/clips
        ln -s /data/media/clips/steam ~/.steam_recording/clips
      '';
      wantedBy = ["multi-user.target"];
    };
    fileSystems."/home/mri/.steam_recording" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=20G" "mode=755" "uid=1000" "gid=1000"];
    };

    # xdg.desktopEntries =-{
    # steam = {
    # name = "Steam";
    # icon = "steam";
    # exec = "env VK_ICD_FILENAMES=\"/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json\" steam %U";
    # terminal = false;
    # type = "Application";
    # mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
    # PrefersNonDefaultGPU = true;
    # X-KDE-RunOnDiscreteGpu = true;
    # };
    # };
  };
}
