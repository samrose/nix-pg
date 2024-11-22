{ pkgs ? import <nixpkgs> {} }:

let
  # Force re-evaluation by adding a timestamp to the derivation name
  packageData = import (pkgs.runCommand "package-data-${builtins.toString __currentTime}.nix" {
  } ''
    ${pkgs.postgresql}/bin/psql \
      "postgresql://postgres:postgres@localhost:5435/postgres" \
      -t -A \
      -c "SELECT '{ name = \"' || name || '\"' || 
         '; version = \"' || version || '\"' ||
         '; buildPhase = \"' || build_phase || '\"' ||
         '; installPhase = \"' || install_phase || '\"' ||
         '; unpackPhase = \"' || unpack_phase || '\"' ||
         '; url = \"' || source_url || '\"' ||
         '; sha256 = \"' || btrim(source_hash, 'sha256-') || '\"' ||
         '; }' FROM packages WHERE name = 'hello-world'" > $out
  '');

  mkPackage = data:
    pkgs.stdenv.mkDerivation {
      inherit (data) name version buildPhase installPhase unpackPhase;
      src = pkgs.fetchurl {
        inherit (data) url sha256;
      };
    };
in {
  example = mkPackage packageData;
}