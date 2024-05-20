{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    steam
  ];

  # support for controllers
  hardware.steam-hardware.enable = true;

  programs.gamemode = {
    enable = true;
    settings.general.inhibit_screensaver = "0";
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
}
