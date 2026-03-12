{...}: {
  # my own modules
  modules.docker.enable = true;
  modules.flatpak.enable = true;
  modules.git.enable = true;
  modules.tmux.enable = true;

  # additional programs
  programs.bat.enable = true;
  programs.imv.enable = true;
  programs.mpv.enable = true;
  programs.ripgrep.enable = true;

  home.shellAliases = {
    cat = "bat -p";
    cd = "z";
  };

  home.file.".ssh/config.template" = {
    source = ./ssh_config.template;
    recursive = true;
  };

  home.sessionPath = [
    "/data/tools/personal/scripts/"
    "$HOME/scripts/"
  ];
}
