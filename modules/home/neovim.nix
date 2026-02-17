{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    # Utils
    ripgrep
    fd
    tree-sitter
  ];

  # Manage Neovim config directly from files inside the Nix repo
  xdg.configFile."nvim" = {
    source = ./neovim;
    recursive = true;
    force = true;
  };
}
