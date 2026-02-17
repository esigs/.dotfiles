{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_22 # Latest LTS or stable
    corepack_22 # For pnpm/yarn management
  ];
}
