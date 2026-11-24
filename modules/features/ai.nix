{
  inputs,
  self,
  ...
}: {
  flake.homeModules.ai = {pkgs, lib, ...}: let
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

    rtk = pkgs.stdenv.mkDerivation {
      pname = "rtk";
      version = "1.2.1";

      src = pkgs.fetchurl {
        url = "https://github.com/rtk-ai/rtk/releases/download/v1.2.1/rtk-x86_64-unknown-linux-musl.tar.gz";
        sha256 = "01dcbddkx4cb98vylh6nnwd9vg94kj98s8kbg9jkbs8vf4jlbxkm";
      };

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        tar -xzf $src rtk
        mkdir -p $out/bin
        install -m755 rtk $out/bin/rtk
        runHook postInstall
      '';
    };

    # PreToolUse hook that transparently rewrites verbose commands through rtk
    # (e.g. `git status` → `rtk git status`) before Claude reads the output.
    rtkHook = pkgs.writeShellScript "rtk-rewrite" ''
      # rtk-hook-version: 4
      export PATH="${rtk}/bin:${pkgs.jq}/bin:$PATH"

      if ! command -v jq &>/dev/null; then
        echo "[rtk] WARNING: jq not found in PATH" >&2
        exit 0
      fi

      if ! command -v rtk &>/dev/null; then
        echo "[rtk] WARNING: rtk not found in PATH" >&2
        exit 0
      fi

      CACHE_DIR=''${XDG_CACHE_HOME:-$HOME/.cache}
      CACHE_FILE="$CACHE_DIR/rtk-hook-version-ok"
      if [ ! -f "$CACHE_FILE" ]; then
        RTK_VERSION_RAW=$(rtk --version 2>/dev/null)
        RTK_VERSION=''${RTK_VERSION_RAW#rtk }
        RTK_VERSION=''${RTK_VERSION%% *}
        if [ -n "$RTK_VERSION" ]; then
          IFS=. read -r MAJOR MINOR PATCH <<<"$RTK_VERSION"
          if [ "$MAJOR" -eq 0 ] && [ "$MINOR" -lt 23 ]; then
            echo "[rtk] WARNING: rtk $RTK_VERSION is too old (need >= 0.23.0)" >&2
            exit 0
          fi
        fi
        mkdir -p "$CACHE_DIR" 2>/dev/null
        touch "$CACHE_FILE" 2>/dev/null
      fi

      INPUT=$(cat)
      CMD=$(jq -r '.tool_input.command // empty' <<<"$INPUT")
      [ -z "$CMD" ] && exit 0

      REWRITTEN=$(env -u RTK_REWRITE_HOST rtk rewrite "$CMD" 2>/dev/null)
      EXIT_CODE=$?

      case $EXIT_CODE in
        0) [ "$CMD" = "$REWRITTEN" ] && exit 0 ;;
        1|2) exit 0 ;;
        3) ;;
        *) exit 0 ;;
      esac

      if [ "$EXIT_CODE" -eq 3 ]; then
        jq -c --arg cmd "$REWRITTEN" \
          '.tool_input.command = $cmd | {"hookSpecificOutput":{"hookEventName":"PreToolUse","updatedInput":.tool_input}}' \
          <<<"$INPUT"
      else
        jq -c --arg cmd "$REWRITTEN" \
          '.tool_input.command = $cmd | {"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"RTK auto-rewrite","updatedInput":.tool_input}}' \
          <<<"$INPUT"
      fi
    '';

    ccstatuslineConfig = pkgs.writeText "ccstatusline-settings.json" (builtins.toJSON {
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
          {
            id = "4";
            type = "context-window";
          }
          {
            id = "5";
            type = "session-usage";
          }
          {
            id = "6";
            type = "weekly-usage";
          }
        ]
      ];
      colorLevel = 0;
      defaultSeparator = "|";
      minimalistMode = true;
      powerline = {enabled = false;};
    });
  in {
    home.packages = [
      pkgs.claude-code
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      ccstatusline
      rtk
      pkgs.jq
    ];

    home.activation.ccstatuslineSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.config/ccstatusline"
      install -m 644 "${ccstatuslineConfig}" "$HOME/.config/ccstatusline/settings.json"
    '';

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
        enabledPlugins = {
          "code-simplifier@claude-plugins-official" = true;
          "claude-md-management@claude-plugins-official" = true;
          "superpowers@claude-plugins-official" = true;
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
        hooks = {
          PreToolUse = [
            {
              matcher = "Bash";
              hooks = [
                {
                  type = "command";
                  command = "${rtkHook}";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
