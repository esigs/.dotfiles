{ pkgs, ... }:

{
  imports = [
    ../../modules/home/default.nix
  ];

  home.packages = with pkgs; [
    discord
  ];
}
