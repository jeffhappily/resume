{
  description = "Jeff Cheah's Resume Builder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Define the Haskell package set
        haskellPackages = pkgs.haskellPackages;

        # Define the resume builder
        resumeBuilder = pkgs.writeShellScriptBin "build-resume" ''
          ${haskellPackages.stack}/bin/stack ${./main.hs} | \
          ${pkgs.wkhtmltopdf}/bin/wkhtmltopdf --dpi 350 - jeff-cheah.pdf
        '';
      in
      {
        packages.default = resumeBuilder;

        apps.default = flake-utils.lib.mkApp { drv = resumeBuilder; };

        devShell = pkgs.mkShell {
          buildInputs = [
            haskellPackages.stack
            pkgs.wkhtmltopdf
            pkgs.xvfb-run  # Including xvfb-run for potential headless environments
          ];
        };
      }
    );
}