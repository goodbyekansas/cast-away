{ sources ? import ./nix/sources.nix }:
let
  pkgs = import sources.nixpkgs {
    overlays = [];
    config = {};
  };

  libcxxStdenvWithStrcmp = pkgs.overrideCC pkgs.libcxxStdenv (pkgs.llvmPackages.override {
    targetLlvmLibraries = (pkgs.llvmPackages.libraries // {
      libcxxabi = pkgs.llvmPackages.libraries.libcxxabi.overrideAttrs (old: {
        CXXFLAGS="-D_LIBCXX_DYNAMIC_FALLBACK=1";
      });
    });
  }).libcxxClang;
in
{
  # libstdc++ (GNU standard library)
  libstd = pkgs.callPackage ./package.nix { stdenv = pkgs.clangStdenv; stdlib = "libstdc++ (GNU)"; };

  # libc++ (llvms standard library)
  libcxx = pkgs.callPackage ./package.nix { stdenv = pkgs.libcxxStdenv; stdlib = "libc++ (LLVM)"; };

  # libc++ (llvms standard library with a strcmp fallback)
  libcxxStrcmp = pkgs.callPackage ./package.nix { stdenv = libcxxStdenvWithStrcmp; stdlib = "libc++ w/ strcmp (LLVM)"; };
}
