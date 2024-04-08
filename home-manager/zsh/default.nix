{ ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      # docker-compose
      dc = "docker-compose";
      dcud = "docker-compose up -d";
      dcl = "docker-compose logs";
      # git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gb = "git branch";
      gr = "git remote";
      # apps
      cat = "bat -p";
      zel = "zellij";
      vim = "nvim";
      icat = "kitten icat";
    };
  };
}
