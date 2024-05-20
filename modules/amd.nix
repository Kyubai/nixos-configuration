{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # amdvlk
      # rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      # driversi686Linux.amdvlk
      # vulkan-loader
      # vulkan-validation-layers
      # vulkan-extension-layer
    ];
  };

  services.xserver.videoDrivers = [ "amdpgu" ];
  hardware.cpu.amd.updateMicrocode = true;
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

  # Esync
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";
}

