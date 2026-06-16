{
  description = "flake for distribution Outscale tools for nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    {
      overlays = import ./overlays {inherit inputs;};
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [self.overlays.outscale];
      };

      terraform-with-outscale = pkgs.terraform.withPlugins (p: [p.outscale_outscale]);
    in {
      formatter = pkgs.alejandra;

      packages = {
        terraform-provider-outscale = pkgs.terraform-providers.outscale_outscale;
        oks-cli = pkgs.oks-cli;
        octl = pkgs.octl;
      };

      devShells.default = pkgs.mkShell {
        packages = [terraform-with-outscale pkgs.octl];

        shellHook = ''
          echo "Available tools: terraform (with outscale provider), octl"
        '';
      };
    });
}
