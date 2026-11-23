# NixOS Config (dendritic pattern)
- `modules/features/` — tools/capabilities; `modules/systems/` — host entrypoints; `modules/groups/` — feature bundles
- All `.nix` files under `modules/` are auto-imported via `import-tree` — new files need `git add` or Nix won't see them
- Features expose `flake.nixosModules.<name>` / `flake.homeModules.<name>`, referenced as `self.nixosModules.<name>`
- Features combine NixOS + home-manager in one file; never split them
- For unstable packages, see `modules/features/desktop.nix`

# Hosts
- `deack-pc-01` — desktop (admin, gaming, browsing)
- `deack-dmz-01` — DMZ host (internet-facing services), public IP `54.38.178.50`
- `deack-docker-01` — internal Docker host (services in `/srv`)
- `fluxer` — VM at `10.99.1.10`, `ssh -p 2201 mri@54.38.178.50`; runs Fluxer (self-hosted chat) + dave-games bot
- Changes to one host MUST NOT break the other

# xorzisten.de
Self-hosted [Fluxer](https://fluxer.app) instance. Public traffic enters at `54.38.178.50` (dmz-01), NPM proxies to the fluxer VM (10.99.1.10).

**Hairpin NAT:** the fluxer VM cannot reach `54.38.178.50` on any port. Any service URL resolving to the public IP must use its internal equivalent:

| Public URL | Internal (from inside fluxer VM / containers) |
|---|---|
| `https://chat.xorzisten.de/api` | `http://edge:8080/api` |
| `wss://chat.xorzisten.de/gateway` | `ws://edge:8080/gateway` |

The `edge` hostname resolves inside the `fluxer_fluxer` Docker network to the Caddy edge container (172.18.0.16). TLS is terminated by NPM on dmz-01; internal traffic is plain HTTP/WS.

The dave-games bot source lives at `/srv/fluxer-dave-games-bot/` on the fluxer VM (local git repo, no remote). Deploy: `sudo docker compose up -d --build`.

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
