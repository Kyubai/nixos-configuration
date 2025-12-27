{
  config,
  lib,
  ...
}: let
  cfgGit = config.modules.git;
in {
  options.modules.git.enable = lib.mkEnableOption "configure git and aliases";

  config =
    lib.mkIf cfgGit.enable
    {
      programs.git.enable = true;

      programs.git.settings = {
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
        # branch.sort = "-commiterdate";

        alias = {
          staash = "stash --all";
          blame = "blame -w -c -c -c";
        };
      };

      home.shellAliases = {
        gs = "git status";
        gc = "git commit";
      };
    };
}
