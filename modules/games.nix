{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgGaming = config.modules.desktop.gaming;
in {
  options.modules.desktop.gaming.enable = mkEnableOption "wine steam and other gaming-related things";

  config = mkIf cfgGaming.enable {
    environment.systemPackages = with pkgs; [
      gamescope
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
      prismlauncher # minecraft client
      mangohud
      runelite
      (wineWowPackages.stable.override {
        # mingwSupport = false;
      })
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
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libkrb5
            keyutils
          ];
      };
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
