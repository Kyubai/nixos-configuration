{
  inputs,
  self,
  ...
}: {
  flake.homeModules.nixos = {
    home.shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos --show-trace --option eval-cache false && git -C /etc/nixos add -A && git -C /etc/nixos commit && git -C /etc/nixos push";
      nix-shell = "nix-shell --run zsh";
      "nix build" = "nix build --print-out-paths";
    };
  };
}
