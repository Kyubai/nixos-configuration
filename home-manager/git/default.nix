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
  };

  home.shellAliases = {
    gs = "git status";
    gc = "git commit";
  };
}
