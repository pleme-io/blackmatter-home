{
  description = "Blackmatter Home — home-level flake.nix provisioning with system management apps";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    substrate = {
      url = "github:pleme-io/substrate";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, substrate, ... }:
    (import "${substrate}/lib/blackmatter-component-flake.nix") {
      inherit self nixpkgs;
      name = "blackmatter-home";
      description = "Home-level flake.nix provisioning";
      modules.homeManager = ./module;
    };
}
