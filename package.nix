{ stdenv, bear, clang-tools, nix-gitignore, stdlib, lib, gdb, enableDebug ? false }:

stdenv.mkDerivation {
  name = "cast-away";

  src = nix-gitignore.gitignoreSource [] ./.;

  nativeBuildInputs = [ bear clang-tools ] ++ lib.optional enableDebug gdb;

  STDLIB = stdlib;
  CXXFLAGS = lib.optional enableDebug "-g";

  dontStrip = enableDebug;

  installPhase = ''
    mkdir -p $out/bin $out/lib

    cp ./cast-away $out/bin
    patchelf --add-rpath "$out/lib" $out/bin/cast-away

    cp ./sloop.so $out/lib
    patchelf --add-rpath "$out/lib" $out/lib/sloop.so

    cp ./libshiploader.so $out/lib
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

    debug() {
      build
      gdb --args ./cast-away ./sloop.so
    }

    export LD_LIBRARY_PATH=''${PWD}:''${LD_LIBRARY_PATH:-}
  '';
}
