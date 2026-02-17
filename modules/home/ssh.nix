{ pkgs, ... }:

let
  sync-ssh-keys = pkgs.writeShellScriptBin "sync-ssh-keys" ''
    exec ${pkgs.babashka}/bin/bb ${./scripts/sync_ssh_keys.bb} "$@"
  '';
in
{
  home.packages = [ sync-ssh-keys ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };
}
