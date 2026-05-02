{ pkgs, local, ... }:

let
  scheme = if local.polarity == "light"
    then "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml"
    else "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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
