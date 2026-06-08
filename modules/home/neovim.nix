{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.clojure
        p.c-sharp
        p.python
        p.lua
        p.vim
        p.vimdoc
        p.query
        p.markdown
        p.markdown_inline
      ]))
    ];
  };

  home.packages = with pkgs; [
    # Utils
    ripgrep
    fd
    tree-sitter

    # Language servers
    pyright
  ];

  # Manage Neovim config directly from files inside the Nix repo
  xdg.configFile."nvim" = {
    source = ./neovim;
    recursive = true;
    force = true;
  };
}
