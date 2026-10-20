{
  description = "My NixOs configuration";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Noctalia Greeter (system login screen)
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      nixpkgs,
      noctalia-greeter,
      ...
    }@inputs:
    {
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./nixos/configuration.nix
            inputs.home-manager.nixosModules.default
            noctalia-greeter.nixosModules.default
          ];
        };
      };
    };
}
