{
  inputs,
  self,
  ...
}: {
  flake.homeModules.ai = {pkgs, ...}: let
    ccstatusline = pkgs.stdenv.mkDerivation {
      pname = "ccstatusline";
      version = "2.2.34";

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.34.tgz";
        sha256 = "10fzbx6y79ssjs9ckwlvrf7vhrklp8qpmwalsc57wxq3hygx2lj0";
      };

      sourceRoot = "package";
      nativeBuildInputs = [pkgs.makeWrapper];
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/ccstatusline
        cp -r dist $out/lib/ccstatusline/
        cp package.json $out/lib/ccstatusline/
        makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ccstatusline \
          --add-flags "$out/lib/ccstatusline/dist/ccstatusline.js"
        runHook postInstall
      '';
    };
  in {
    home.packages = [
      pkgs.claude-code
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      ccstatusline
    ];

    home.file.".config/ccstatusline/settings.json" = {
      text = builtins.toJSON {
        version = 3;
        lines = [
          [
            {
              id = "1";
              type = "model";
            }
            {
              id = "2";
              type = "git-branch";
            }
            {
              id = "3";
              type = "current-working-dir";
            }
          ]
        ];
        colorLevel = 0;
        defaultSeparator = "|";
        minimalistMode = true;
        powerline = {enabled = false;};
      };
    };

    home.file.".claude/settings.json" = {
      force = true;
      text = builtins.toJSON {
        attribution = {
          commit = "";
          pr = "";
        };
        statusLine = {
          type = "command";
          command = "ccstatusline";
          refreshInterval = 10;
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
