{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.notebook = {
    lib,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [224];
          events = ["key"];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set '5%-'";
        }
        {
          keys = [225];
          events = ["key"];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set '5%+'";
        }
      ];
    };
  };
}
