{
  inputs,
  self,
  ...
}: {
  flake.homeModules.claude = {pkgs, ...}: {
    home.packages = [pkgs.claude-code];

    home.file.".claude/settings.json" = {
      force = true;
      text = builtins.toJSON {
        attribution = {
          commit = "";
          pr = "";
        };
        permissions.allow = [
          "Bash(sudo nixos-rebuild switch --flake /etc/nixos*)"
          "Bash(git add*)"
          "Bash(git commit*)"
          "Bash(git diff*)"
          "Bash(niri validate)"
          "Bash(ls*)"
          "Bash(grep*)"
          "Read(/tmp/screenshot.png)"
        ];
      };
    };
  };
}
