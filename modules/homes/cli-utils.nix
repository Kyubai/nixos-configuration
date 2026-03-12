{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.cli-utils = {
    home-manager.sharedModules = [
      self.homeModules.eza
      self.homeModules.neovim
      self.homeModules.zellij
      self.homeModules.zsh
      self.homeModules.starship
      self.homeModules.zoxide
      self.homeModules.nix-index
      self.homeModules.nixos
      self.homeModules.home-manager
    ];
  };

  #   flake.modules.home-manager.cli-utils = {
  #     imports = [
  #       self.homeModules.eza
  #       self.homeModules.neovim
  #       self.homeModules.zellij
  #       self.homeModules.zsh
  #       self.homeModules.starship
  #       self.homeModules.zoxide
  #       self.homeModules.nix-index
  #       self.homeModules.nixos
  #       self.homeModules.home-manager
  #     ];
  #   };
}
