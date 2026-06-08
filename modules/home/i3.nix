{ config, pkgs, lib, ... }:

let
  inherit (import ./lib/palette.nix { inherit config; }) c;
  barColors = import ./lib/i3-bar-colors.nix { inherit c; };
  wallpaper = ../../wallpaper.jpg;
  mod = "Mod4";
in {
  imports = [ ./i3-status.nix ];

  home.packages = with pkgs; [
    flameshot
    pulseaudio
    networkmanagerapplet
    blueman
    feh
    papirus-icon-theme
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          trayOutput = "primary";
          fonts.size = 14.0;
          colors = barColors;
        }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec alacritty";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show drun";
        "Print" = "exec flameshot gui";

        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";

        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+r" = "mode resize";
      };

      workspaceLayout = "default";

      startup = [
        { command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}"; always = true; notification = false; }
        { command = "nm-applet"; always = true; notification = false; }
        { command = "blueman-applet"; always = true; notification = false; }
        # Force horizontal split so new windows tile side-by-side.
        { command = "i3-msg split h"; always = true; notification = false; }
      ];
    };
  };

  programs.alacritty.enable = true;

  programs.rofi = {
    enable = true;
    font = lib.mkForce "JetBrainsMono Nerd Font Mono 14";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "  Apps";
      drun-display-format = "{name}";
      modi = "drun,run,window";
    };
  };
}
