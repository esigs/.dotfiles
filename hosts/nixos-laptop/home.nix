{ lib, pkgs, config, ... }:

let
  inherit (import ../../modules/home/lib/palette.nix { inherit config; }) c;
  barColors = import ../../modules/home/lib/i3-bar-colors.nix { inherit c; };

  mkBar = { output, fontSize, tray }: {
    position = "bottom";
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
    trayOutput = tray;
    extraConfig = "output ${output}";
    fonts.size = fontSize;
    colors = barColors;
  };
in {
  imports = [ ../../modules/home/default.nix ];

  xsession.windowManager.i3.config.bars = lib.mkForce [
    (mkBar { output = "DP-2-1"; fontSize = 14.0; tray = "DP-2-1"; })
    (mkBar { output = "eDP-1";  fontSize = 16.0; tray = "eDP-1";  })
    (mkBar { output = "HDMI-1"; fontSize = 14.0; tray = "HDMI-1"; })
  ];

  # Monitor layout: DP-2-1 at work, HDMI-1 at home — both left of the laptop screen.
  xsession.windowManager.i3.config.startup = lib.mkAfter [
    { command = "xrandr --output DP-2-1 --auto --left-of eDP-1"; always = true; notification = false; }
    { command = "xrandr --output HDMI-1 --auto --left-of eDP-1"; always = true; notification = false; }
  ];
}
