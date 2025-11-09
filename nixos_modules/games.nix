{
  config,
  inputs,
  lib,
  nixpkgs-stable,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.gaming;
  pkgs-stable = import nixpkgs-stable {
    config.allowUnfree = true;
  };
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  options.modules.desktop.gaming.enable = mkEnableOption "wine steam and other gaming-related things";
  options.modules.desktop.gaming.vr.enable = mkEnableOption "enable vr support";

  config = mkMerge [
    (mkIf cfg.vr.enable {
      environment.systemPackages = with pkgs; [
        # alvr # VR streaming
        wivrn
        wlx-overlay-s
        unityhub # for 3d avatar modelling
      ];
      # https://wiki.nixos.org/wiki/VR
      # services.monado = {
      # enable = true;
      # defaultRuntime = true; # Register as default OpenXR runtime
      # };

      # systemd.user.services.monado.environment = {
      # STEAMVR_LH_ENABLE = "1";
      # XRT_COMPOSITOR_COMPUTE = "1";
      # };

      programs.git = {
        enable = true;
        lfs.enable = true;
      };

      services.wivrn = {
        enable = true;
        openFirewall = true;

        # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
        # will automatically read this and work with WiVRn (Note: This does not currently
        # apply for games run in Valve's Proton)
        defaultRuntime = true;

        # Run WiVRn as a systemd service on startup
        autoStart = true;

        # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
        config = {
          enable = true;
          json = {
            # 1.0x foveation scaling
            scale = 1.0;
            # 100 Mb/s
            bitrate = 100000000;
            encoders = [
              {
                encoder = "vaapi";
                codec = "h265";
                # 1.0 x 1.0 scaling
                width = 1.0;
                height = 1.0;
                offset_x = 0.0;
                offset_y = 0.0;
              }
            ];
          };
        };
      };

      programs.envision = {
        enable = true;
        openFirewall = true; # This is set true by default
      };

      boot.kernelPatches = [
        {
          name = "amdgpu-ignore-ctx-privileges";
          patch = pkgs.fetchpatch {
            name = "cap_sys_nice_begone.patch";
            url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
            hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
          };
        }
      ];
    })
    (mkIf cfg.enable {
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
        # runelite
        bolt-launcher # runescape
        steamtinkerlaunch
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
          sleep 30
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
    })
  ];
}
