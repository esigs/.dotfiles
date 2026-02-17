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
