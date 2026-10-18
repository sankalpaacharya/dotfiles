{
  description = "Sankalpa's macOS setup: nix-darwin + home-manager + nix-homebrew";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      me = import ./me.nix;

      mkDarwinHost =
        hostName:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs hostName me; };
          modules = [ ./darwin.nix ];
        };
    in
    {
      darwinConfigurations = {
        sankalpas-macbook-pro = mkDarwinHost "sankalpas-macbook-pro";
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
