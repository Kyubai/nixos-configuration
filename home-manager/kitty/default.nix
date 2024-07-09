{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.5";
      enable_audio_bell = false;
      draw_minimal_border = true;
      disable_ligatures = "always";
      update_check_interval = 0;
      term = "kitty";
    };
    theme = "Tokyo Night";
    keybindings = {
      "ctrl+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+c" = "send_text all \\x03"; # SIGINT
      "ctrl+shift+v" = "send_text all \\x16"; # Pastchar
    };
  };

  home.sessionVariables = {
    TERM = "kitty";
  };
}
