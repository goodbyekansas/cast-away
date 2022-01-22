{ stdenv, bear, clang-tools, nix-gitignore, stdlib }:

stdenv.mkDerivation {
  name = "cast-away";

  src = nix-gitignore.gitignoreSource [] ./.;

  nativeBuildInputs = [ bear clang-tools ];

  STDLIB = stdlib;

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
