{ config, pkgs, user, local, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/i3.nix
    ../../modules/system/common.nix
  ];

  networking.hostName = "nixos-desktop";

  boot.initrd.luks.devices."luks-044569af-44d1-4913-bace-ff6ffe4bf0ef".device = "/dev/disk/by-uuid/044569af-44d1-4913-bace-ff6ffe4bf0ef";

  # NVIDIA GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];
  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib";
  };
}
