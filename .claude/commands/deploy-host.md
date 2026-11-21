---
description: Deploy a new NixOS host with impermanence, srv-compose, and disko via nixos-anywhere
allowed-tools: Bash(ssh-keygen *), Bash(git *), Bash(nix *), Bash(nixos-anywhere *), Bash(nixos-rebuild *), Bash(nixos-rebuild switch *), Bash(ssh *), Bash(age *), Bash(mkdir *), Bash(cp *), Bash(chmod *), Bash(ls *), Bash(grep *), Bash(until *), Bash(nix copy *), Write, Edit, Read, AskUserQuestion
---

## Context

You are deploying a new NixOS host into this repo. Read the existing patterns before writing any files.

Current systems: !`ls /etc/nixos/modules/systems/`
Agenix rules: !`cat /etc/nixos/secrets/agenix-rules.nix`
Recent commits: !`git -C /etc/nixos log --oneline -5`

Reference host (same platform, same feature set): `deack-dmz-01`
Reference config: !`cat /etc/nixos/modules/systems/deack-dmz-01/configuration.nix`

## Arguments

$ARGUMENTS

If the arguments don't specify all required values, ask the user for them before starting:
- **hostname** (e.g. `deack-docker-02`)
- **disk device** on the target (e.g. `/dev/sda` or `/dev/vda`)
- **target IP and SSH port** where the NixOS install ISO is running (e.g. `192.168.1.50` port `22`, or `54.38.178.50` port `2201`)
- **ISO root password**
- **networking**: DHCP (default) or static IP

## Steps

Work through each step in order. Do not skip ahead.

### 1 — Generate SSH host key

```bash
ssh-keygen -t ed25519 -f /tmp/ssh_host_ed25519_key -N ""
cat /tmp/ssh_host_ed25519_key.pub
```

Note the public key — it is needed for agenix in the next step.

### 2 — Update agenix rules

In `/etc/nixos/secrets/agenix-rules.nix`:
- Add `<hostname>-host = "<public key>";` alongside the other host variables
- Add `<hostname>-host` to `restic-wasabi.age`'s `publicKeys` list

### 3 — Rekey `restic-wasabi.age`

**Do not run `agenix --rekey`** — it will abort on `nas-credentials.age` (which `deack-dmz-01` can't decrypt) before it ever reaches `restic-wasabi.age`.

Instead, re-encrypt it directly. Read **all current** `publicKeys` for `restic-wasabi.age` from `agenix-rules.nix` — every existing recipient must be included or they will lose access. Then ask the user to run this on deack-dmz-01:

```bash
# Ask user to run:
ssh -A mri@deack-dmz-01 'sudo sh -c "
  cd /etc/nixos \
  && git pull \
  && age -d -i /etc/ssh/ssh_host_ed25519_key secrets/restic-wasabi.age \
  | age -e \
    -r \"<deack-dmz-01-host key>\" \
    -r \"<deack-docker-01-host key>\" \
    -r \"<...any other existing recipient keys>\" \
    -r \"<new host public key>\" \
    > /tmp/restic-new.age \
  && cp /tmp/restic-new.age secrets/restic-wasabi.age \
  && rm /tmp/restic-new.age \
  && git add secrets/restic-wasabi.age \
  && git commit -m \"secrets: rekey restic-wasabi for <hostname>\" \
  && git push"'
```

After the user confirms it ran, `git pull` on deack-pc-01.

### 4 — Create host configuration

Create `/etc/nixos/modules/systems/<hostname>/configuration.nix`.

**CRITICAL requirements** (all learned from deployment — omitting any one will cause boot or activation failure):

| Setting | Why |
|---|---|
| `imports = [(modulesPath + "/profiles/qemu-guest.nix")]` | Proxmox/QEMU platform — provides correct virtio drivers |
| `boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"]` | Without these the initrd can't see `/dev/sda` on first boot |
| `nixpkgs.hostPlatform = "x86_64-linux"` | No `hardware-configuration.nix` exists, so must be explicit |
| `boot.initrd.systemd.enable = false` | NixOS 26.05 defaults to systemd initrd, which doesn't support `postDeviceCommands` |
| `fileSystems."/persist".neededForBoot = true` | Required by the impermanence module |
| `age.identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"]` | `agenixInstall` runs before impermanence bind-mounts; `/persist` is a real btrfs subvolume mounted in stage 1, so it's always available |
| `nix.settings.trusted-users = ["mri"]` | Allows `nix copy` from deack-pc-01 without signature errors |

Disko layout (BIOS/GRUB + btrfs):
- `disk.main`, device = `<disk device>`
- Partition 1: 1M, EF02 (BIOS boot — GRUB infers device from this, no need to set `boot.loader.grub.device`)
- Partition 2: 100% remaining, btrfs, label `nixos`
  - Subvolume `/root` → mountpoint `/`, options `["subvol=root" "compress=zstd" "noatime"]`
  - Subvolume `/nix` → mountpoint `/nix`, options `["subvol=nix" "compress=zstd" "noatime"]`
  - Subvolume `/persist` → mountpoint `/persist`, options `["subvol=persist" "compress=zstd" "noatime"]`

The `boot.initrd.postDeviceCommands = lib.mkAfter` script:
```bash
mkdir /mnt
mount -t btrfs /dev/disk/by-label/nixos /mnt
btrfs subvolume delete /mnt/root
btrfs subvolume create /mnt/root
sync
umount /mnt
```

Modules list: `base`, `cli-utils`, `agenix`, `impermanence`, `srv-compose`, `inputs.disko.nixosModules.disko` (inline), `home-manager` (sharedModules: `cli-utils` for both mri and root, stateVersion `25.11`).

Additional host-specific settings matching `deack-dmz-01`:
- `boot.loader.grub.enable = true`
- `boot.supportedFilesystems = ["btrfs"]`
- `networking.hostName = "<hostname>"`
- `networking.networkmanager.enable = true` (for DHCP) — if static, also set `networking.networkmanager.ensureProfiles` with `method = "manual"`, `address1 = "<ip>/<prefix>,<gateway>"`, `dns = "<dns-server>;"`. Verify the DNS entry is an actual resolver, not just the gateway.
- `services.openssh.enable = true`, `PermitRootLogin = "no"`
- `security.sudo.extraRules` — NOPASSWD for mri
- `users.users.mri` — isNormalUser, groups `["wheel" "networkmanager"]`, authorizedKey for `mri@deack-pc-01`
- `nix.settings.experimental-features = ["nix-command" "flakes"]`, `auto-optimise-store = true`
- `system.stateVersion = "25.11"`

**Restic on hosts without NAS:** The `srv-compose` module hardcodes `/mnt/media/...` backup paths. For hosts without a NAS mount, override to avoid backup failures:
```nix
services.restic.backups.wasabi.paths = lib.mkForce ["/srv"];
```

**Restic timer staggering:** All hosts share the same Wasabi repo — concurrent runs cause lock conflicts. Current schedule: `deack-dmz-01` → 05:00, `deack-docker-01` → 05:30. Each new host should add 15 minutes:
```nix
services.restic.backups.wasabi.timerConfig = lib.mkForce {
  OnCalendar = "05:45:00";  # increment by 15m per host
  Persistent = true;
};
```

### 5 — Stage, commit, and push

```bash
git -C /etc/nixos add modules/systems/<hostname>/configuration.nix secrets/agenix-rules.nix
git -C /etc/nixos commit -m "feat: add <hostname> host with impermanence and srv-compose"
git -C /etc/nixos push
```

### 6 — Prepare extra-files

The SSH host keys must land in `/persist/etc/ssh/` so they survive the btrfs root wipe on first boot:

```bash
mkdir -p /tmp/nax-extra/persist/etc/ssh
cp /tmp/ssh_host_ed25519_key /tmp/nax-extra/persist/etc/ssh/
cp /tmp/ssh_host_ed25519_key.pub /tmp/nax-extra/persist/etc/ssh/
chmod 600 /tmp/nax-extra/persist/etc/ssh/ssh_host_ed25519_key
```

### 7 — Deploy with nixos-anywhere

```bash
SSHPASS=<iso-root-password> nixos-anywhere \
  --flake /etc/nixos#<hostname> \
  --extra-files /tmp/nax-extra \
  --env-password \
  --ssh-port <port> \
  root@<target-ip>
```

Omit `--ssh-port` if using the standard port 22. The target does **not** need internet access — nixos-anywhere pushes the entire closure from deack-pc-01 over SSH. Warnings about `cache.nixos.org` being unreachable are non-fatal.

Watch for errors. Common first-run issues are covered in the Troubleshooting section below.

### 8 — Wait for reboot and verify

First add the host key (the one generated in Step 1) to known_hosts, otherwise SSH will refuse to connect:

```bash
ssh-keyscan -p <port> <target-ip> 2>/dev/null >> ~/.ssh/known_hosts
```

Then wait for the host to come up. After nixos-anywhere reboots it, connect on the **permanent IP** (not the ISO IP), standard port 22 unless a port-forward is configured:

```bash
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 mri@<target-ip> 'echo up' 2>/dev/null; do sleep 5; done
ssh mri@<target-ip> 'hostname && systemctl is-active docker && ls /persist && sudo ls /run/agenix/'
```

The agenix secret `restic-wasabi` must appear in `/run/agenix/`. All three timers must be active: `nixos-upgrade.timer`, `docker-compose-update.timer`, `restic-backups-wasabi.timer`.

### 9 — Clone nixos config to /persist

The `clone-nixos-config` systemd service (defined in `base.nix`) runs automatically on first boot and clones the repo if `/etc/nixos/.git` is absent. If the host has internet access, nothing further is needed — verify with:

```bash
ssh mri@<target-ip> 'sudo systemctl status clone-nixos-config'
```

**If the host has no internet access**, the service will fail. Fall back to rsync from deack-pc-01:

```bash
sudo rsync -az -e "ssh -p <port>" --rsync-path="sudo rsync" /etc/nixos/ mri@<target-ip>:/persist/etc/nixos/
```

Note: without outbound internet, `auto-upgrade`, restic backups to Wasabi, and the clone service will all fail until routing is fixed at the network/Proxmox level.

---

## Troubleshooting

**After install, host boots back into the ISO**
→ The VM boot order has CD-ROM before the hard disk. In Proxmox, either detach the ISO from the CD drive or move the hard disk above the CD-ROM in the boot order. Then reboot — the installed NixOS on `/dev/sda` will start normally.

**Boot fails — "disk-main-root does not exist" or "by-label/nixos does not exist"**
→ The initrd kernel modules are missing. Ensure `availableKernelModules` and `qemu-guest.nix` are present. Reboot to ISO and redeploy.

**Boot fails — scripted initrd assertion about `postDeviceCommands`**
→ NixOS 26.05 defaults to systemd initrd. Add `boot.initrd.systemd.enable = false`. Reboot to ISO and redeploy.

**Boot fails — impermanence assertion about `neededForBoot`**
→ Add `fileSystems."/persist".neededForBoot = true`. Reboot to ISO and redeploy.

**agenix "no readable identities found" after boot**
→ Activation ordering issue: `agenixInstall` runs before impermanence sets up the `/etc/ssh` bind-mount. Set `age.identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"]`. Then rebuild remotely (see below).

**`nix copy` fails — "lacks a signature by a trusted key"**
→ The nix daemon on the target rejects unsigned paths from non-root. Bootstrap fix: create a temporary drop-in and restart nix-daemon: `sudo mkdir -p /etc/nix/nix.conf.d && echo "trusted-users = root mri" | sudo tee /etc/nix/nix.conf.d/trusted.conf && sudo systemctl restart nix-daemon`. Then `nix copy --no-check-sigs ...`. Once the proper config (with `trusted-users`) is applied this is no longer needed.

**Remote `nixos-rebuild` killed (OOM)**
→ The host has limited RAM. Create a temporary swapfile before rebuilding:
```bash
ssh mri@<target-ip> 'sudo btrfs subvolume create /swap && sudo btrfs filesystem mkswapfile --size 2g /swap/swapfile && sudo swapon /swap/swapfile'
```
Then retry the rebuild. (The swap subvolume is on the ephemeral root and disappears on next reboot — that's fine for a one-time build.)

**After fixing issues, pushing config to the host without nixos-anywhere**
Build locally and push:
```bash
sudo nixos-rebuild build --flake /etc/nixos#<hostname>
nix copy --no-check-sigs --to ssh://mri@<target-ip> $(readlink result)
ssh mri@<target-ip> "sudo $(readlink result)/bin/switch-to-configuration switch"
```
