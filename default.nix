{ sources ? import ./nix/sources.nix }:
let
  pkgs = import sources.nixpkgs {
    overlays = [];
    config = {};
  };

  libcxxStdenvWithStrcmp = pkgs.overrideCC pkgs.llvmPackages_11.libcxxStdenv (pkgs.llvmPackages_11.override {
    targetLlvmLibraries = (pkgs.llvmPackages_11.libraries // {
      libcxxabi = pkgs.llvmPackages_11.libraries.libcxxabi.overrideAttrs (old: {
        CXXFLAGS="-D_LIBCXXABI_FORGIVING_DYNAMIC_CAST=1";
      });
    });
  }).libcxxClang;
in
{
  # libstdc++ (GNU standard library)
  libstd = pkgs.callPackage ./package.nix { stdenv = pkgs.llvmPackages_11.stdenv; stdlib = "libstdc++ (GNU)"; };

  # libc++ (llvms standard library)
  libcxx = pkgs.callPackage ./package.nix { stdenv = pkgs.llvmPackages_11.libcxxStdenv; stdlib = "libc++ (LLVM)"; };

  # libc++ (llvms standard library with a strcmp fallback)
  libcxxStrcmp = pkgs.callPackage ./package.nix { stdenv = libcxxStdenvWithStrcmp; stdlib = "libc++ w/ strcmp (LLVM)"; };
}
