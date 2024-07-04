{ ...
}:
{
  programs.git.enable = true;

  programs.git.extraConfig = {
    init = {
      defaultBranch = "main";
    };
    user = {
      email = "public@verriegelt.net";
      name = "Matthias Riegel";
    };
    pull = {
      ff = "only";
    };
    safe = {
      directory = "/etc/nixos";
    };
    push = {
        autoSetupRemote = true;
    };
    rerere.enabled = true;
    column.ui = "auto";
    branch.sort = "-commiterdate";
  };

  programs.git.aliases = {
    staash = "stash --all";
    blame = "blame -w -c -c -c";
  };

  home.shellAliases = {
    gs = "git status";
    gc = "git commit";
  };
}
