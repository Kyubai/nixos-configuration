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
  # modules.hyprland = {
  # enable = true;
  # terminal = "alacritty";
  # };
  modules.i3.enable = true;
  # modules.sway.enable = true;
  # modules.steam.enable = true;
  # modules.alacritty.enable = true;

  programs.home-manager.enable = true;                                                                                                                                                                                                                        
  home.stateVersion = "23.11";
}
