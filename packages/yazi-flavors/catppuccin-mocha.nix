{ lib, pkgs, fetchFromGitHub }:
let
  flavor = "catppuccin-mocha";
in
pkgs.stdenv.mkDerivation {
  pname = "yazi-flavor-${flavor}";
  version = "2026-01-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "ca6165818bb84d46af5fd8f95bedd2b1c395890a";
    hash = lib.fakeHash;
  };

  installPhase = ''
    mkdir -p "$out"
    cp "$src/${flavor}.yazi"/* "$out/"
  '';
}
