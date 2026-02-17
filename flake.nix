{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Handle sudo by checking SUDO_USER, otherwise fall back to HOME
      homeDir = let
        sudoUser = builtins.getEnv "SUDO_USER";
      in if sudoUser != "" then "/home/${sudoUser}" else builtins.getEnv "HOME";
      
      localFile = homeDir + "/.config/nixos-config/local.nix";
      local = if builtins.pathExists localFile
              then import localFile
              else throw "Local configuration file not found at ${localFile}. Please create it to proceed.";
      user = if builtins.hasAttr "user" local
             then local.user
             else throw "The 'user' attribute is missing in ${localFile}. Please define it.";
    in {
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs user; };
      modules = [
        ./hosts/nixos/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit inputs user; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./hosts/nixos/home.nix;
        }
      ];
    };
  };
}
