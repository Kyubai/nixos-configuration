{...}: {
  # my own modules
  modules.docker.enable = true;
  modules.eza.enable = true;
  modules.flatpak.enable = true;
  modules.git.enable = true;
  modules.neovim.enable = true;
  modules.tmux.enable = true;
  modules.zellij.enable = true;
  modules.zsh.enable = true;

  # additional programs
  programs.bat.enable = true;
  programs.imv.enable = true;
  programs.mpv.enable = true;
  programs.ripgrep.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # zoxide is a cd alternative
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  home.shellAliases = {
    cat = "bat -p";
    cd = "z";
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos --show-trace --option eval-cache false && git -C /etc/nixos add -A && git -C /etc/nixos commit && git -C /etc/nixos push";
    hms = "pushd /etc/nixos && home-manager switch --extra-experimental-features \"nix-command flakes\" --flake .#$USER && popd";
    nix-shell = "nix-shell --run zsh";
    "nix build" = "nix build --print-out-paths";
  };

  home.sessionPath = [
    "/data/tools/personal/scripts/"
    "$HOME/scripts/"
  ];
}
