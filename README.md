# NixOS Config

## Setup
Create `local.nix` in the root of this repository:
```nix
{
  user = "your_username";
  work = {
    name = "Full Name";
    email = "work@email.com";
  };
  personal = {
    name = "Full Name";
    email = "personal@email.com";
  };
}
```

## Apply
```bash
apply
```
Or manually:
```bash
sudo nixos-rebuild switch --flake path:.#nixos-desktop --impure
```

## SSH Key Sync
SSH keys are managed in Bitwarden as an "SSH Key" item named `Personal SSH-key`. To pull them to your local machine:

1. Log in and unlock Bitwarden:
   ```bash
   bw login
   export BW_SESSION=$(bw unlock --raw)
   ```
2. Run the sync tool:
   ```bash
   sync-ssh-keys
   ```

This will write `id_ed25519` and `id_ed25519.pub` to `~/.ssh/` with the correct permissions.
