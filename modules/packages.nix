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
    pa_applet
    pavucontrol
    xfce.thunar
    tmux
    tree
    unzip
    xclip
    zip
    libreoffice

    # language servers 
    bash-language-server
    clojure-lsp
    lua-language-server
    nixd
  ];
}
