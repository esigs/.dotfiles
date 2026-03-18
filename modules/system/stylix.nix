{ pkgs, local, ... }:

let
  scheme = if local.polarity == "light"
    then "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml"
    else "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
in {
  stylix = {
    enable = true;
    base16Scheme = scheme;
    polarity = local.polarity;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sizes.terminal = 12;
    };
  };
}
