{
  inputs,
  self,
  ...
}: {
  flake.homeModules.cli-utils = {
    imports = [
      self.homeModules.bat
      self.homeModules.claude
      self.homeModules.docker
      self.homeModules.eza
      self.homeModules.git
      self.homeModules.home-manager
      self.homeModules.neovim
      self.homeModules.nix-index
      self.homeModules.nixos
      self.homeModules.ripgrep
      self.homeModules.ssh
      self.homeModules.starship
      self.homeModules.theme
      self.homeModules.zellij
      self.homeModules.zoxide
      self.homeModules.zsh
    ];

    home.sessionPath = ["$HOME/scripts"];
  };
}
