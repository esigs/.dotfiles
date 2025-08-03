{ userConfig, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ stow ];

  system.activationScripts.dotfiles = {
    text = ''
      echo "Stowing dotfiles for user ${userConfig.username}..."
      ${pkgs.stow}/bin/stow -d /home/${userConfig.username}/.dotfiles/home -t /home/${userConfig.username} .
    '';
  };
}
