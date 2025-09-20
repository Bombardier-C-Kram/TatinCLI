{
  description = "raylibAPL is a library made to write cross-platform graphical applications using the Dyalog APL programming language";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, flake-utils, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  in flake-utils.lib.eachSystem systems (system:
    let
      # Configure Nix to allow unfree packages.
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      dyalog = pkgs.dyalog.override { acceptLicense = true; };
      tatinCLI = import ./default.nix {
        inherit (pkgs) stdenv lib;
        inherit dyalog;
      };
    in {
      packages.default = tatinCLI;
      devShells.default = import ./shell.nix {inherit pkgs tatinCLI dyalog;};
    }
  );
}
