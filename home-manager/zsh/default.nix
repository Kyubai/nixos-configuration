{ ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      # ls
      ls = "eza";
      la = "eza -a";
      ll = "eza -l --time-style long-iso";
      lh = "eza -lh --time-style long-iso";
      lla = "eza -la --time-style long-iso";
      lha = "eza -lha --time-style long-iso";
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
