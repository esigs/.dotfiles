{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ls = "ls -la";
      # Nix management
      apply = "echo 'Running: sudo nixos-rebuild switch --flake path:. --impure' && sudo nixos-rebuild switch --flake path:. --impure";
      update = "echo 'Running: nix flake update && rebuild' && nix flake update && sudo nixos-rebuild switch --flake path:. --impure";
      test = "echo 'Running: nixos-rebuild test (no boot entry)' && sudo nixos-rebuild test --flake path:. --impure";
      dry = "echo 'Running: nixos-rebuild dry-build' && nixos-rebuild dry-build --flake path:. --impure 2>&1 | head -50";
      clean = "echo 'Running: sudo nix-collect-garbage --delete-older-than 7d' && sudo nix-collect-garbage --delete-older-than 7d";
      rollback = "echo 'Running: sudo nixos-rebuild switch --rollback' && sudo nixos-rebuild switch --rollback";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
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
