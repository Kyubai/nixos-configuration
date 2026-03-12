{
  inputs,
  self,
  ...
}: {
  flake.homeModules.zellij = {
    programs.zellij = {
      enable = true;
      # enableBashIntegration = true;
      # enableZshIntegration = true;
      settings = {
        default_shell = "zsh";
        theme = "tokyo-night-storm";
        copy_on_select = true;
        pane_frames = false;
        show_startup_tips = false;
      };
    };
  };
}
