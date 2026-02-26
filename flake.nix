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
      localFile = ./local.nix;
      local = if builtins.pathExists localFile
              then import localFile
              else throw "Local configuration file not found at ${toString localFile}. Please create it from the template.";
      user = if builtins.hasAttr "user" local
             then local.user
             else throw "The 'user' attribute is missing in local.nix. Please define it.";

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs user local; };
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit inputs user local; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./hosts/${hostname}/home.nix;
          }
        ];
      };
    in {
      nixosConfigurations = {
        nixos-desktop = mkHost "nixos-desktop";
        nixos-laptop = mkHost "nixos-laptop";
        # Future hosts:
        # ...
      };
    };
}
