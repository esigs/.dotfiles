{ config, pkgs, user, local, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/i3.nix
    ../../modules/system/common.nix
  ];

  networking.hostName = "nixos-laptop";

  boot.initrd.luks.devices."luks-d9299f58-f5e1-4243-b5fb-eb2e5f6ac918".device = "/dev/disk/by-uuid/d9299f58-f5e1-4243-b5fb-eb2e5f6ac918";

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Power management
  services.tlp.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;

  # Jabra speaker priority
  services.pipewire.wireplumber.extraConfig."10-jabra-priority" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.usb-0b0e_Jabra_SPEAK_410.*"; } ];
        actions.update-props = { "priority.driver" = 1500; "priority.session" = 1500; };
      }
      {
        matches = [ { "node.name" = "~alsa_input.usb-0b0e_Jabra_SPEAK_410.*"; } ];
        actions.update-props = { "priority.driver" = 1500; "priority.session" = 1500; };
      }
    ];
  };

}
