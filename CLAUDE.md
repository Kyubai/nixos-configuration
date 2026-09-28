`sudo nixos-rebuild switch --flake /etc/nixos --show-trace --option eval-cache false` Will rebuild the NixOS config. Do this after making changes to test them.
After the rebuild create a new commit and push to origin.
`niri validate` allows you to check the niri config syntax after changing it. Always run this after making changes to niri
