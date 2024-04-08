{ ... }:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = import ./.vimrc;
  };
  
}
