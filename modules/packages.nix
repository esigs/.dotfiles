{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    
    alacritty
    bitwarden-cli
    chromium
    curl
    docker
    docker-compose
    firefox
    flameshot
    git
    htop
    libreoffice
    neovim
    networkmanagerapplet
    pa_applet
    pavucontrol
    tmux
    tree
    unzip
    xclip
    xfce.thunar
    zip

    # language servers 
    bash-language-server
    clojure-lsp
    lua-language-server
    nixd
  ];
}
