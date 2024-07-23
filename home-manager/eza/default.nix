{ ... }:
{
  programs.eza.enable = true;
  home.shellAliases = {
    ls = "eza --time-style long-iso";
    la = "eza -a";
    ll = "eza -l --time-style long-iso";
    lh = "eza -lh --time-style long-iso";
    lla = "eza -la --time-style long-iso";
    lha = "eza -lha --time-style long-iso";
  };
}
