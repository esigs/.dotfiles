{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/default.nix
  ];

  # Two bars: external display at 14pt, internal display at 16pt
  xsession.windowManager.i3.config.bars = lib.mkForce [
    {
      position = "bottom";
      statusCommand = "${pkgs.i3status}/bin/i3status";
      trayOutput = "DP-2-1";
      extraConfig = "output DP-2-1";
      fonts = { size = 14.0; };
    }
    {
      position = "bottom";
      statusCommand = "${pkgs.i3status}/bin/i3status";
      trayOutput = "eDP-1";
      extraConfig = "output eDP-1";
      fonts = { size = 16.0; };
    }
  ];

  # Laptop-specific user settings
  xsession.windowManager.i3.config.startup = lib.mkAfter [
    # Monitor setup: Set external monitor (DP-2-1) to the left of laptop screen (eDP-1)
    { command = "xrandr --output DP-2-1 --auto --left-of eDP-1"; always = true; notification = false; }
  ];
}
