# NixOS Config

## Setup
Create `~/.config/nixos-config/local.nix`:
```nix
{
  work = {
    name = "Eric Sigurdson";
    email = "eric.sigurdson@raw-digital.com";
  };
  personal = {
    name = "Eric Sigurdson";
    email = "eric@ericsigurdson.com";
  };
}
```

## Apply
```bash
sudo nixos-rebuild switch --flake .#nixos-desktop --impure
```
