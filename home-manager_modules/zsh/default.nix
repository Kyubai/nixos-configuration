{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgZsh = config.modules.zsh;
in {
  options.modules.zsh.enable = lib.mkEnableOption "enable zsh terminal";

  config = lib.mkIf cfgZsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;

      history = {
        ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event
        saveNoDups = true; # Do not write duplicate entries into the history file
      };

      syntaxHighlighting = {
        enable = true;
      };

      # zprof.enable = true; # enable profiling

      # defaultKeymap = "viins"; # replaced by zsh-vi-mode
      initContent = ''
        # create a zkbd compatible hash;
        # to add other keys to this hash, see: man 5 terminfo
        typeset -g -A key

        key[Home]="''${terminfo[khome]}"
        key[End]="''${terminfo[kend]}"
        key[Insert]="''${terminfo[kich1]}"
        key[Backspace]="''${terminfo[kbs]}"
        key[Delete]="''${terminfo[kdch1]}"
        key[Up]="''${terminfo[kcuu1]}"
        key[Down]="''${terminfo[kcud1]}"
        key[Left]="''${terminfo[kcub1]}"
        key[Right]="''${terminfo[kcuf1]}"
        key[PageUp]="''${terminfo[kpp]}"
        key[PageDown]="''${terminfo[knp]}"
        key[Shift-Tab]="''${terminfo[kcbt]}"

        # setup key accordingly
        [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"       beginning-of-line
        [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"        end-of-line
        [[ -n "''${key[Insert]}"    ]] && bindkey -- "''${key[Insert]}"     overwrite-mode
        [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}"  backward-delete-char
        [[ -n "''${key[Delete]}"    ]] && bindkey -- "''${key[Delete]}"     delete-char
        [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"         up-line-or-history
        [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"       down-line-or-history
        [[ -n "''${key[Left]}"      ]] && bindkey -- "''${key[Left]}"       backward-char
        [[ -n "''${key[Right]}"     ]] && bindkey -- "''${key[Right]}"      forward-char
        [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"     beginning-of-buffer-or-history
        [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"   end-of-buffer-or-history
        [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}"  reverse-menu-complete

        # Finally, make sure the terminal is in application mode, when zle is
        # active. Only then are the values from ''$terminfo valid.
        if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
        	autoload -Uz add-zle-hook-widget
        	function zle_application_mode_start { echoti smkx }
        	function zle_application_mode_stop { echoti rmkx }
        	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
        	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
        fi

        key[Control-Left]="''${terminfo[kLFT5]}"
        key[Control-Right]="''${terminfo[kRIT5]}"

        [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"  backward-word
        [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}" forward-word

        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        [[ -n "''${key[Up]}"   ]] && bindkey -- "''${key[Up]}"   up-line-or-beginning-search
        [[ -n "''${key[Down]}" ]] && bindkey -- "''${key[Down]}" down-line-or-beginning-search

        key[Control-Left]="''${terminfo[kLFT5]}"
        key[Control-Right]="''${terminfo[kRIT5]}"

        [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"  backward-word
        [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}" forward-word

        bindkey "^[[3;5~" kill-word
        bindkey "^H" backward-kill-word
        bindkey "^R" history-beginning-search-backward
        # bindkey "''${key[Up]}" up-line-or-search # not sure if this works

        # only compinit once a day
        # https://gist.github.com/ctechols/ca1035271ad134841284
        autoload -Uz compinit
        if [[ -n ''${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
          compinit;
        else
          compinit -C;
        fi;

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select # arrow key completion
        zstyle ':completion::complete:*' gain-privileges 1 # activate arrow key tab-menu

      '';
      plugins = [
        #  {
        #    name = "vi-mode";
        #    src = pkgs.zsh-vi-mode;
        #    file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        #  }
        {
          name = "zsh-completions"; # more autosuggestion
          src = "${pkgs.zsh-completions}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell"; # enter nix-shell with zsh by default
          src = pkgs.zsh-nix-shell;
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
        }
      ];
      sessionVariables = {
        ZVM_VI_ESCAPE_BINDKEY = "jk"; # used by zsh-vi-mode
      };
    };
  };
}
