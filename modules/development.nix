{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cargo
    clang
    gcc
    rustc
    pkg-config
  ];
}
