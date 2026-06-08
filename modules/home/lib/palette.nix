{ config }:

let
  palette = builtins.fromJSON (builtins.readFile "${config.xdg.configHome}/stylix/palette.json");
in {
  inherit palette;
  c = color: "#${palette.${color}}FF";
}
