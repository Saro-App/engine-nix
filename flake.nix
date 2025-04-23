# Copyright (C) 2025 Ethan Uppal. All rights reserved.
{
  description = "Wine build flake for arm64 macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    packages.aarch64-darwin.default = let
      pkgsArm = import nixpkgs {
        system = "aarch64-darwin";
      };
      pkgsIntel = import nixpkgs {
        system = "x86_64-darwin";
      };
    in
      pkgsArm.callPackage ./wine.nix {
        inherit pkgsArm pkgsIntel;
      };
  };
}
