{ pkgs, ... }:
{
  imports = [
    ./eza
    ./git
    ./i3
    ./kitty
    ./neovim
    ./steam
    ./sway
    ./theme
    ./vim
    ./waybar
    ./zsh
  ];


  programs.bat.enable = true;
  programs.imv.enable = true;
  programs.mpv.enable = true;
  programs.tmux = {
    enable = true;
    mouse = true;
  };
  programs.ripgrep.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # zoxide cd alternative
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  home.shellAliases = {
    cat = "bat -p";
    cd = "z";
    nrs = "nixos-rebuild switch --flake /etc/nixos";
    hms = "home-manager switch --extra-experimental-features \"nix-command flakes\" --flake .#$USER";
  };

  home.sessionVariables = {
    BROWSER = "vivaldi";
    # add nvim?
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
