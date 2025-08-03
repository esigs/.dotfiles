{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    
    alacritty
    bitwarden-cli
    chromium
    curl
    firefox
    flameshot
    git
    htop
    neovim
    networkmanagerapplet
    tmux
    tree
    unzip
    xclip
    zip

    # language servers 
    bash-language-server
    clojure-lsp
    lua-language-server
    nixd
  ];
}
