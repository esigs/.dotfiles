{ lib, ... }:

{
  imports = [
    ../../modules/home/default.nix
  ];

  # Laptop-specific user settings
  xsession.windowManager.i3.config.startup = [
    # Monitor setup: Set external monitor (DP-2-1) to the left of laptop screen (eDP-1)
    { 
      command = "xrandr --output DP-2-1 --auto --left-of eDP-1";
      always = true; 
      notification = false; 
    }
  ];
}
