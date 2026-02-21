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

    # C#
    (with dotnetCorePackages; combinePackages [
      sdk_8_0
      sdk_9_0
    ])
    roslyn-ls
    powershell
  ];
}
