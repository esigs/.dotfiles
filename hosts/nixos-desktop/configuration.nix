{ config, pkgs, user, local, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/i3.nix
    ../../modules/system/common.nix
  ];

  networking.hostName = "nixos-desktop";

  # NVIDIA driver + base graphics live in hardware-configuration.nix; only the 32-bit override is here.
  hardware.graphics.enable32Bit = true;

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
