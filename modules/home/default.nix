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
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoStash = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      core.fsmonitor = true;
      core.untrackedCache = true;
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Stylix manages neovim config via symlink, disable its auto-theming for neovim
  stylix.targets.neovim.enable = false;
}
