{
	description = "Basic NixOS flake with local configuration and packages";

	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

	outputs = { self, nixpkgs }:
		let
	userConfig = { username = "erics";};
	userModule = { ... }: { _module.args.userConfig = userConfig; };

	mkHost = name: config-path:
		nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				userModule
				config-path
				./modules/packages.nix
				./modules/run-stow.nix
				./modules/i3.nix
			];
		};


	in {
		nixosConfigurations = {
			x1 = mkHost "x1" ./hosts/x1/configuration.nix;
		};
	};
}
