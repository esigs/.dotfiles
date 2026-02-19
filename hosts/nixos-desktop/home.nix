{ config, pkgs, user, local, ... }:

{
  imports = [
    ../../modules/home/zsh.nix
    ../../modules/home/packages.nix
    ../../modules/home/i3.nix
    ../../modules/home/tmux.nix
    ../../modules/home/neovim.nix
    ../../modules/home/ssh.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.11";


  # Individual user packages can go here
  home.packages = with pkgs; [
    # ripgrep
    # fd
  ];

  programs.home-manager.enable = true;

  # Integrated programs
  programs.firefox.enable = true;
  programs.chromium = {
	enable = true;
	extensions = [
		{ id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
	];
   };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
    };
    includes = [
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/work/";
        contents = {
          user = {
            name = local.work.name;
            email = local.work.email;
          };
        };
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/repos/personal/";
        contents = {
          user = {
            name = local.personal.name;
            email = local.personal.email;
          };
        };
      }
    ];
  };

  # Dark mode preference
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
