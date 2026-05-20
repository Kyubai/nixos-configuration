{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.sway = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      grimblast # screenshot utility
      hyprpaper # wallpaper
      # https://wiki.nixos.org/wiki/Dolphin
      kdePackages.dolphin # file manager
      kdePackages.kio
      kdePackages.kdf
      kdePackages.qtsvg # icons for dolphin
      kdePackages.kio-fuse # to mount remote filesystems via FUSE
      kdePackages.kio-extras # extra protocols support (sftp, fish and more)
      kdePackages.kio-admin
      kdePackages.qtwayland # Qt wayland support
      kdePackages.plasma-integration
      kdePackages.breeze-icons
      kdePackages.kservice
      kdePackages.plasma-workspace # required for dolphin applications menu
      shared-mime-info
      slurp # geometry selector
      swappy # screenshot editor
      wl-screenrec # screen recording utility
      wayland
      wdisplays # manage monitors
      wl-clipboard # clipboard cli
      # kdePackages.xwaylandvideobridge # not present in 25.11
      # portals
      xdg-desktop-portal-gtk # required for themes?
      kdePackages.xdg-desktop-portal-kde
    ];
    environment.sessionVariables = {
      WLR_RENDERER = "pixman";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.getty = {
      autologinUser = "mri";
      autologinOnce = true;
    };
    environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && sway
    '';

    #     services.greetd = {
    #       enable = true;
    #       settings = {
    #         terminal = {
    #           vt = 1;
    #         };
    #         default_session = {
    #           command = "${pkgs.greetd}/bin/agreety --cmd sway";
    #           user = "mri";
    #         };
    #         initial_session = {
    #           command = "${pkgs.greetd}/bin/agreety --cmd sway";
    #           user = "mri";
    #         };
    #       };
    #     };

    # programs.xwayland = true;
    programs.sway = {
      enable = true;
      # xwayland.enable = true;
      # withUWSM = true;
      # portalPackage = pkgs.xdg-desktop-portal-hyprland;
      # wrapperFeatures.gtk = true;
    };
    #     programs.uwsm = {
    #       enable = true;
    #       waylandCompositors.hyprland = {
    #         prettyName = "Hyprland";
    #         comment = "Hyprland compositor managed by UWSM";
    #         # binPath = lib.getExe pkgs.hyprland;
    #         binPath = "/run/current-system/sw/bin/Hyprland";
    #       };
    #     };
    # programs.hyprlock.enable = true;

    # xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      # wlr.enable = false; # disable wlr when using hyprland
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk # required for themes?
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        common = {
          default = ["*"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
      };
    };
    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs, printing and others.
    services.dbus.enable = lib.mkDefault true;
    security.polkit.enable = true;
  };

  flake.homeModules.sway = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      # self.homeModules.ashell
      self.homeModules.kitty
    ];
    services.dunst.enable = true; # notification deamon
    programs.wofi.enable = true; # dmenu

    gtk.enable = true; # required for portals?

    home.pointerCursor = {
      hyprcursor.enable = true;
      package = pkgs.nordzy-cursor-theme; # cursor theme
      name = "Nordzy-hyprcursors";
    };

    wayland.windowManager.sway = {
      enable = true;
      # set packages to null to use nixos defined package
      # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
      # package = null;
      # portalPackage = null;
      systemd.enable = true;
      systemd.variables = ["--all"];
      # systemd.enableXdgAutostart = true;
      extraConfig = ''
      '';

      # xwayland.enable = true;
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        # "$menu" = "wofi -S drun -i";
        # "$fileManager" = "dolphin";
        # debug = {
        # disable_logs = false;
        # };
        #         input = {
        # kb_layout = "eu";
        # };
      };
    };
  };
}
