{ config, ... }:

let
  inherit (import ./lib/palette.nix { inherit config; }) c;
in {
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      theme = "plain";
      settings.theme.overrides = {
        idle_bg = c "base00";
        idle_fg = c "base05";
        info_bg = c "base0D";
        info_fg = c "base00";
        good_bg = c "base0B";
        good_fg = c "base00";
        warning_bg = c "base0A";
        warning_fg = c "base00";
        critical_bg = c "base08";
        critical_fg = c "base00";
        separator_bg = c "base00";
        separator = " ";
      };
      blocks = [
        { block = "net"; }
        {
          block = "battery";
          format = " $icon $percentage $time ";
          missing_format = "";
        }
        { block = "disk_space"; path = "/"; info_type = "available"; }
        { block = "load"; }
        { block = "memory"; }
        {
          block = "sound";
          driver = "pulseaudio";
          show_volume_when_muted = true;
          click = [{ button = "left"; cmd = "pavucontrol"; }];
        }
        {
          block = "time";
          interval = 5;
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
        }
      ];
    };
  };
}
