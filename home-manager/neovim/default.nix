{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = import ./.vimrc;
  };

  home.shellAliases = {
    vim = "nvim";
  };
}
