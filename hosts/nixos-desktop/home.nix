{ config, pkgs, user, local, ... }:

{
  imports = [
    ../../modules/home/zsh.nix
    ../../modules/home/packages.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
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
