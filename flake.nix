{
  description = "A very simple Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      hello =
        {stdenv, cmake, ...}:
        stdenv.mkDerivation {
          name = "hello";
          src = ./.;
          nativeBuildInputs = [ cmake ];
        };
    in
    {
      packages = {
        x86_64-linux =
          let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            pkgs-static = pkgs.pkgsStatic;
            pkgs-windows = pkgs.pkgsCross.mingwW64;
            pkgs-aarch64 = pkgs.pkgsCross.aarch64-multiplatform;
          in
          {
            default = self.packages.x86_64-linux.hello;
            hello = pkgs.callPackage hello {};
            hello-static = pkgs-static.callPackage hello {};
            hello-windows = pkgs-windows.callPackage hello {};
            hello-aarch64 = pkgs-aarch64.callPackage hello {};
          };
        aarch64-darwin =
          let
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          in
          {
            default = self.packages.x86_64-linux.hello;
            hello = pkgs.callPackage hello {};
          };
        x86_64-darwin =
          let
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          in
          {
            default = self.packages.x86_64-linux.hello;
            hello = pkgs.callPackage hello {};
          };
      };
    };
}
