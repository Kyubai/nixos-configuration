{
  inputs,
  self,
  ...
}: {
  flake.homeModules.alacritty = {
    lib,
    pkgs,
    ...
  }: {
    programs.alacritty = {
      enable = true;
      settings = {
        env.LIBGL_ALWAYS_SOFTWARE = "1";
      };
    };
  };
}
