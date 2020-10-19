{ pkgs ? import <nixpkgs> { }, stdenv ? pkgs.stdenv, lib ? pkgs.lib
, maven ? pkgs.maven, callPackage ? pkgs.callPackage }:
# pick a repository derivation, here we will use buildMaven
let repository = callPackage ./build-maven-repository.nix { };
in stdenv.mkDerivation rec {
  pname = "maven-demo";
  version = "1.0";

  src = builtins.fetchTarball
    "https://github.com/fzakaria/nixos-maven-example/archive/main.tar.gz";
  buildInputs = [ maven ];

  buildPhase = ''
    echo "Using repository ${repository}"
    mvn --offline -Dmaven.repo.local=${repository} package;
  '';

  installPhase = ''
    install -Dm644 target/${pname}-${version}.jar $out/share/java
  '';
}
