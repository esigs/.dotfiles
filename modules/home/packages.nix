{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_22
    bitwarden-cli
    
    # Clojure
    clojure
    babashka
    clojure-lsp
    
    # Utils
    unzip
    jq
  ];
}
