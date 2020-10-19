{ pkgs ? import <nixpkgs> { }, stdenv ? pkgs.stdenv, maven ? pkgs.maven }:
with stdenv;
mkDerivation {
  name = "maven-repository";
  buildInputs = [ maven ];
  src = ./.; # or fetchFromGitHub, cleanSourceWith, etc
  buildPhase = ''
    mvn package -Dmaven.repo.local=$out
  '';

  # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
  installPhase = ''
    find $out -type f \
      -name \*.lastUpdated -or \
      -name resolver-status.properties -or \
      -name _remote.repositories \
      -delete
  '';

  # don't do any fixup
  dontFixup = true;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "08fyvc7462pa541pxinchdglfhiwbxa1ws8y67vd1hr22km5nmd1";
}
