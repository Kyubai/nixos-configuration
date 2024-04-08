{ ... }:
{
  home.file.".config/i3/config".source = ./config;

  home.file.".xinitrc" = {
    text = ''
    exec i3
    '';
  };
}
