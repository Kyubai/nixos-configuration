{
  inputs,
  self,
  ...
}: {
  flake.homeModules.cli-utils = {
    imports = [
      self.homeModules.eza
      self.homeModules.git
      self.homeModules.home-manager
      self.homeModules.neovim
      self.homeModules.nix-index
      self.homeModules.nixos
      self.homeModules.starship
      self.homeModules.zellij
      self.homeModules.zoxide
      self.homeModules.zsh
    ];
  };
}
