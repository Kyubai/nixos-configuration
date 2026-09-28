{
  inputs,
  self,
  ...
}: {
  flake.homeModules.git = {pkgs, ...}: {
    programs.git.enable = true;

    programs.git.hooks.commit-msg = pkgs.writeShellScript "strip-coauthored-by" ''
      sed -i '/^Co-authored-by:/Id' "$1"
    '';

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
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gch = "git checkout";
      gcl = "git clone";
      gp = "git pull";
      gs = "git status";
    };
  };
}
