{ user, ... }:

{
  imports = [
    ./zsh.nix
    ./packages.nix
    ./i3.nix
    ./tmux.nix
    ./neovim.nix
    ./ssh.nix
    ./browsers.nix
    ./git.nix
    ./starship.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  # Neovim theme is handled by base16-nvim reading ~/.config/stylix/palette.json directly.
  stylix.targets.neovim.enable = false;
}
