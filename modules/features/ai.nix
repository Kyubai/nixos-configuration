{
  inputs,
  self,
  ...
}: {
  flake.homeModules.ai = {pkgs, ...}: let
    gjc = pkgs.stdenv.mkDerivation {
      pname = "gajae-code";
      version = "0.22.0";
      src = pkgs.fetchurl {
        url = "https://github.com/Yeachan-Heo/gajae-code/releases/download/v0.22.0/gjc-linux-x64";
        sha256 = "02piy149iighwspgms756dj4hpj0hvf7yhqrmcq4a3yi03z184sm";
      };
      dontUnpack = true;
      dontBuild = true;
      # Bun standalone executables embed bytecode after the ELF sections.
      # patchelf corrupts those offsets, so invoke through ld.so directly.
      installPhase = ''
        mkdir -p $out/bin $out/libexec
        cp $src $out/libexec/gjc-unwrapped
        chmod +x $out/libexec/gjc-unwrapped
        cat > $out/bin/gjc <<WRAPPER
        #!${pkgs.runtimeShell}
        exec ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 --library-path ${pkgs.glibc}/lib $out/libexec/gjc-unwrapped "\$@"
        WRAPPER
        chmod +x $out/bin/gjc
      '';
    };
  in {
    home.packages = [
      pkgs.claude-code
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      gjc
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
