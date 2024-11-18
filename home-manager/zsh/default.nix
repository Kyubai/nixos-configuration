{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    # defaultKeymap = "viins";
    initExtra = ''
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[3;5~" kill-word
      bindkey "^H" backward-kill-word
      bindkey "^R" history-beginning-search-backward
    '';
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };
}
