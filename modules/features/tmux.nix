{
  inputs,
  self,
  ...
}: {
  flake.homeModules.tmux = {
    lib,
    pkgs,
    ...
  }: {
    programs.tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      newSession = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        nord
      ];
      extraConfig = ''
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind -n M-h select-pane -L
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U
        bind -n M-j select-pane -D

        set -g @plugin "nordtheme/tmux"
      '';
    };
  };
}
