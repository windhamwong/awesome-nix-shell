{
  nixpkgs ? <nixpkgs>, system ? builtins.currentSystem
}:

with import nixpkgs { inherit system; };

stdenv.mkDerivation {
  name = "nixos-shell";
  src = ./.;
  buildInputs = [ go ];
  phases = [ "buildPhase" ];
  buildPhase =
    ''
    mkdir -p $out/bin
    '';
  shellHook =
    ''
    export GOPATH=`pwd`/go
    export PATH=$PATH:`pwd`/go/bin

    '';
}