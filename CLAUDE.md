# What is this
This is a repo for managing the configuration of multiple systems using NixOS and home-manager, employing the dendritic pattern
`./modules/features/` contains features, like tools or capabilities
`./modules/systems/` contains the entrypoints the systems
`./modules/groups` defines groups, which combine multiple features, so they don't have be explitely enabled in each system

You can see which system you're currently working on by looking at the hostname
`deack-pc-01` is my desktop pc at home, which I use for administration, gaming and browsing

# General Guidelines
If you're unsure what to do, or could use additional information from me, you MUST prompt me
Features MUST not be seperated by NixOS vs home-manager and CAN be combined in one file

# Validation of changes
## All changes for NixOS and the repo
`sudo nixos-rebuild switch --flake /etc/nixos --show-trace --option eval-cache false` Will rebuild the NixOS config
You MUST add new files to the git staging area. They won't be picked up by nix otherwise
You SHOULD do this after making changes to test them

After the rebuild create a new commit and push to origin.
You SHOULD add and commit on your own
You SHOULD follow best practices for git commits, like separatings features into multiple commits, especially when they happen to different files
You MUST prompt me before pushing

`ssh-add` will add the SSH key for pushing the commit

## Changes for specific features
`niri validate` allows you to check the niri config syntax after changing it. Always run this after making changes to niri
