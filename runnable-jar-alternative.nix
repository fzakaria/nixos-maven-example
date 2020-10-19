{ pkgs ? import <nixpkgs> { }, stdenv ? pkgs.stdenv, lib ? pkgs.lib
, maven ? pkgs.maven, callPackage ? pkgs.callPackage
, makeWrapper ? pkgs.makeWrapper, jre ? pkgs.jre }:
let
  repository = callPackage ./build-maven-repository.nix { };
in stdenv.mkDerivation rec {
  pname = "maven-demo";
  version = "1.0";

  src = builtins.fetchTarball
    "https://github.com/fzakaria/nixos-maven-example/archive/main.tar.gz";
  buildInputs = [ maven makeWrapper ];

  buildPhase = ''
    echo "Using repository ${repository}"
    mvn --offline -Dmaven.repo.local=${repository} package;
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java

    classpath=$(find ${repository} -name "*.jar" -printf ':%h/%f');
    install -Dm644 target/${pname}-${version}.jar $out/share/java
    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
          --add-flags "-classpath $out/share/java/${pname}-${version}.jar:''${classpath#:}" \
          --add-flags "Main"
  '';
}
