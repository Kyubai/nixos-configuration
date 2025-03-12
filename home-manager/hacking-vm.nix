{...}: {
  imports = [
    ./default.nix
  ];

  services.copyq.enable = true;

  home.sessionVariables = {
    BROWSER = "vivaldi";
    EDITOR = "nvim";
  };

  # my own modules
  modules.hyprland = {
    enable = true;
    terminal = "alacritty";
  };
  modules.alacritty.enable = true;
}
