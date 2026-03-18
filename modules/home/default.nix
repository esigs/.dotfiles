{ config, user, local, ... }:

{
  imports = [
    ./zsh.nix
    ./packages.nix
    ./i3.nix
    ./tmux.nix
    ./neovim.nix
    ./ssh.nix
    ./browsers.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

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

  # Stylix manages neovim config via symlink, disable its auto-theming for neovim
  stylix.targets.neovim.enable = false;
}
