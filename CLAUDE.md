# NixOS Config (dendritic pattern)
- `modules/features/` — tools/capabilities; `modules/systems/` — host entrypoints; `modules/groups/` — feature bundles
- All `.nix` files under `modules/` are auto-imported via `import-tree` — new files need `git add` or Nix won't see them
- Features expose `flake.nixosModules.<name>` / `flake.homeModules.<name>`, referenced as `self.nixosModules.<name>`
- Features combine NixOS + home-manager in one file; never split them
- For unstable packages, see `modules/features/desktop.nix`

# Hosts
- `deack-pc-01` — desktop (admin, gaming, browsing)
- `deack-dmz-01` — DMZ host (internet-facing services)
- Changes to one host MUST NOT break the other

# Rules
- Ask before acting if unsure
- Use Nix for all changes, not dotfiles directly
- Read official docs before source code
- Screenshots are at `/tmp/screenshot.png`

# Remote hosts
Edit locally → commit + push → `sudo git -C /etc/nixos pull` on remote → rebuild there.

# Validation & Commit
```bash
sudo nixos-rebuild switch --flake /etc/nixos --show-trace --option eval-cache false
```
- Stage new files before rebuilding (`git add`)
- After a successful rebuild: commit and push
- Use `git add` / `git commit` directly (not `git -C`)
- Split features into separate commits when touching different files
- After niri changes: `niri validate`
