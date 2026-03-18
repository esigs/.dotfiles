{ pkgs, ... }:

{
  programs.firefox.enable = true;
  stylix.targets.firefox.profileNames = [ "default" ];

  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
    extensions = [
      { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
    ];
  };

  programs.google-chrome.enable = true;
}
