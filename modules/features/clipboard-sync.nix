{inputs, ...}: {
  flake.nixosModules.clipboard-sync = {
    lib,
    pkgs,
    config,
    ...
  }: let
    waylandEnabled =
      (config.programs.sway.enable)
      || (config.programs.hyprland.enable);

    clipsync =
      inputs.wl-x11-clipsync.packages.${pkgs.system}.default;
  in {
    config = lib.mkIf waylandEnabled {
      # sync host to vm
      systemd.user.services.wl-x11-clipsync = {
        description = "Synchronize Wayland and X11 clipboards";

        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];

        serviceConfig = {
          ExecStart = "${clipsync}/bin/clipsync";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
      # sync vm to host
      systemd.user.services.wl-paste = {
        description = "Synchronize Wayland and X11 clipboards";

        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];

        path = with pkgs; [
          wl-clipboard
          xclip
        ];

        serviceConfig = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste -w ${pkgs.xclip}/bin/xclip -i";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
  };
}
