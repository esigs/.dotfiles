{ config, local, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoStash = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      core.fsmonitor = true;
      core.untrackedCache = true;
    };
    includes = [
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/brokerdev/";
        contents = {
          user = {
            name = local.work2.name;
            email = local.work2.email;
            signingKey = local.work2.signingKey;
          };
          commit.gpgsign = true;
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
        };
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/work/";
        contents.user = {
          name = local.work.name;
          email = local.work.email;
        };
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/personal/";
        contents.user = {
          name = local.personal.name;
          email = local.personal.email;
        };
      }
    ];
  };

  home.file.".ssh/allowed_signers".text = ''
    ${local.work2.email} ${builtins.readFile "${local.work2.signingKey}.pub"}
  '';
}
