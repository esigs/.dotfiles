{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      command_timeout = 1000;
      directory.truncation_length = 3;
      git_status.disabled = false;
      nix_shell.disabled = true;

      # Hide language version clutter.
      java.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      rust.disabled = true;
      golang.disabled = true;
      package.disabled = true;
    };
  };
}
