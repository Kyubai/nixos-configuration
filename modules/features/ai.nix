{
  inputs,
  self,
  ...
}: {
  flake.homeModules.ai = {pkgs, ...}: {
    home.packages = [
      pkgs.claude-code
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    ];

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
          "Bash(head*)"
          "Bash(tail*)"
          "Read(/tmp/screenshot.png)"
          "Bash(journalctl*)"
          "Bash(systemctl status*)"
          "Bash(systemctl list-units*)"
          "Bash(systemctl list-unit-files*)"
          "Bash(systemctl is-active*)"
          "Bash(systemctl is-enabled*)"
          "Bash(systemctl cat*)"
          "Bash(systemctl show*)"
        ];
      };
    };
  };
}
