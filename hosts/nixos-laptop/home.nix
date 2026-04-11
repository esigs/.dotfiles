{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/default.nix
  ];

  # Two bars: external display at 14pt, internal display at 16pt
  xsession.windowManager.i3.config.bars = lib.mkForce [
    {
      position = "bottom";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
      trayOutput = "DP-2-1";
      extraConfig = "output DP-2-1";
      fonts = { size = 14.0; };
    }
    {
      position = "bottom";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
      trayOutput = "eDP-1";
      extraConfig = "output eDP-1";
      fonts = { size = 16.0; };
    }
    {
      position = "bottom";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
      trayOutput = "HDMI-1";
      extraConfig = "output HDMI-1";
      fonts = { size = 14.0; };
    }
  ];

  # Laptop-specific user settings
  xsession.windowManager.i3.config.startup = lib.mkAfter [
    # Monitor setup: work (DP-2-1 left of laptop) or home (HDMI-1 above laptop)
    { command = "xrandr --output DP-2-1 --auto --left-of eDP-1"; always = true; notification = false; }
    { command = "xrandr --output HDMI-1 --auto --above eDP-1"; always = true; notification = false; }
  ];
}
