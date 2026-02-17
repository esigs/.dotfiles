{ config, pkgs, user, ... }:

let
  localFile = "${config.home.homeDirectory}/.config/nixos-config/local.nix";
  local = if builtins.pathExists localFile
          then import localFile
          else throw "Local configuration file not found at ${localFile}. Please create it to proceed.";
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
    includes = [
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/work/";
        contents = {
          user = {
            name = local.work.name;
            email = local.work.email;
          };
        };
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/personal/";
        contents = {
          user = {
            name = local.personal.name;
            email = local.personal.email;
          };
        };
      }
    ];
  };

  # Individual user packages can go here
  home.packages = with pkgs; [
    # ripgrep
    # fd
  ];

  programs.home-manager.enable = true;
}
