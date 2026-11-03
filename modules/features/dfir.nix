{...}: {
  flake.nixosModules.dfir = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      evtx # evtx_dump - Windows XML Event Log parser
    ];
  };
}
