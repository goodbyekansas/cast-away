{ stdenv, bear, clang-tools, nix-gitignore }:

stdenv.mkDerivation {
  name = "cast-away";

  src = nix-gitignore.gitignoreSource [] ./.;

  nativeBuildInputs = [ bear clang-tools ];

  STDLIB = if stdenv.cc.cc.lib.isGNU or false then "libstdc++ (GNU)" else "libc++ (LLVM)";

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp ./cast-away $out/bin
    cp ./sloop.so $out/lib
  '';

  shellHook = ''
    bear() {
      command bear -- make clean all
    }

    build() {
      make "$@"
    }

    run() {
      ./cast-away "$@"
    }
  '';
}
