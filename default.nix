{ sources ? import ./nix/sources.nix }:
let
  pkgs = import sources.nixpkgs {
    overlays = [];
    config = {};
  };
in
{
  # libstdc++ (GNU standard library)
  libstd = pkgs.callPackage ./package.nix { stdenv = pkgs.clangStdenv; };

  # libc++ (llvms standard library)
  libcxx = pkgs.callPackage ./package.nix { stdenv = pkgs.libcxxStdenv; };
}
