{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./alacritty
    # ./ashell
    ./docker
    ./eza
    ./flatpak
    ./git
    ./hyprland
    ./i3
    ./japanese-input
    ./kitty
    ./neovim
    ./opencomposite
    ./polybar
    ./ssh
    ./steam
    ./sway
    ./theme
    ./tmux
    ./waybar
    ./zellij
    ./zsh
  ];
}
