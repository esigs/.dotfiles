{ lib, pkgs, config, ... }:

let
  paletteJSON = builtins.readFile "${config.xdg.configHome}/stylix/palette.json";
  palette = builtins.fromJSON paletteJSON;
  c = color: "#${palette.${color}}FF";

  barColors = {
    background = c "base00";
    statusline = c "base05";
    separator = c "base03";
    focusedWorkspace = { border = c "base0D"; background = c "base0D"; text = c "base00"; };
    activeWorkspace = { border = c "base02"; background = c "base02"; text = c "base05"; };
    inactiveWorkspace = { border = c "base00"; background = c "base00"; text = c "base05"; };
    urgentWorkspace = { border = c "base08"; background = c "base08"; text = c "base00"; };
  };

  mkBar = { output, fontSize, tray }: {
    position = "bottom";
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
    trayOutput = tray;
    extraConfig = "output ${output}";
    fonts = { size = fontSize; };
    colors = barColors;
  };
in {
  imports = [
    ../../modules/home/default.nix
  ];

  # Multi-monitor bars
  xsession.windowManager.i3.config.bars = lib.mkForce [
    (mkBar { output = "DP-2-1"; fontSize = 14.0; tray = "DP-2-1"; })
    (mkBar { output = "eDP-1"; fontSize = 16.0; tray = "eDP-1"; })
    (mkBar { output = "HDMI-1"; fontSize = 14.0; tray = "HDMI-1"; })
  ];

  # Laptop-specific user settings
  xsession.windowManager.i3.config.startup = lib.mkAfter [
    # Monitor setup: work (DP-2-1 left of laptop) or home (HDMI-1 above laptop)
    { command = "xrandr --output DP-2-1 --auto --left-of eDP-1"; always = true; notification = false; }
    { command = "xrandr --output HDMI-1 --auto --left-of eDP-1"; always = true; notification = false; }
  ];
}
