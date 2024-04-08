{ ... }:
{
  home.file.".config/i3/config".source = ./config;

  home.file.".xinitrc" = {
    text = ''
    vmware-user &
    exec i3
    '';
  };
}
