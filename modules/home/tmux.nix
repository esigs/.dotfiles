{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 10000;
    extraConfig = ''
      # Open new windows in specific directories
      bind h new-window -c "~/"
      bind c new-window -c "#{pane_current_path}"

      # {pane_current_path} is the current pane’s directory (from tmux)
      # git -C <path> rev-parse --show-toplevel gives the git root for that directory
      # The fallback echo "#{pane_current_path}" makes sure you still open a new window in the current directory if it's not a git repo.

      bind g run-shell 'tmux new-window -c "$(git -C "#{pane_current_path}" rev-parse --show-toplevel 2>/dev/null || echo "#{pane_current_path}")"'

      # Set vi mode
      set-window-option -g mode-keys vi

      # Copy mode keybindings (Vi style)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle \; send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"


      # Move windows left/right (e.g., move nvim window to position 0)
      bind -r < swap-window -t -1\; select-window -t -1
      bind -r > swap-window -t +1\; select-window -t +1

      bind j command-prompt -p "join pane from window: " "join-pane -s '%%'"
    '';
  };
}
