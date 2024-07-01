{ ... }:
{
  # home.file.".config/i3/config".source = ./config;
  xsession.windowManager.i3 = {
    enable = true;
    # wrapperFeatures.gtk = true;
    # extraConfig= (import ./config);
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      floating = {
        titlebar = false;
      };
      # bars =  [
      #   {
      #     mode = "hide";
      #     position = "bottom";
      #   }
      # ];
    };
  };

  home.file.".xinitrc" = {
    text = ''
    exec i3
    '';
  };
}
