{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      apply = "echo 'Running: sudo nixos-rebuild switch --flake path:. --impure' && sudo nixos-rebuild switch --flake path:. --impure";
    };

    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    # p10k setup
    initContent = ''
      # Optional: Source p10k config if it exists
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Auto-start/attach tmux
      if [[ -z "$TMUX" ]] && [[ "$-" == *"i"* ]]; then
        tmux attach-session -t default 2>/dev/null || tmux new-session -s default
      fi
    '';

    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];
  };

  # Required to make zsh the default shell properly in NixOS
  home.packages = with pkgs; [
    zsh-completions
    nix-zsh-completions
  ];
}
