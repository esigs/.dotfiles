{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-cli
    nodejs_22
    
    # Clojure
    babashka
    clojure
    clojure-lsp
    clj-kondo
    polylith
    
    # Utils
    jq
    unzip
  ];
}
