{ pkgs ? import <nixpkgs> {} }:

let
  queryDbPure = query:
    let
      queryHash = builtins.hashString "sha256" query;
      # Force unique hash by including timestamp in derivation name
      result = pkgs.runCommand "db-query-${queryHash}-${builtins.toString pkgs.stdenv.hostPlatform.system}" {} ''
        ${pkgs.postgresql}/bin/psql \
            "postgresql://postgres:postgres@localhost:5435/postgres" \
          -t \
          -A \
          -c "${query}" > $out
      '';
      value = builtins.fromJSON (builtins.readFile result);
    in {
      value = builtins.trace "DB Result: ${builtins.toJSON value}" value;
    };

  mkPackageFromDb = name:
    let
      query = ''
        SELECT json_agg(json_build_object(
          'name', name,
          'version', version,
          'buildPhase', build_phase,
          'installPhase', install_phase,
          'source_url', source_url,
          'source_hash', source_hash,
          'unpackPhase', unpack_phase
        ))
        FROM packages 
        WHERE name = '${name}'
      '';
      info = queryDbPure query;
      packageInfo = builtins.head info.value;
      hash = builtins.replaceStrings ["sha256-"] [""] packageInfo.source_hash;
    in
    pkgs.stdenv.mkDerivation {
      inherit (packageInfo) name version buildPhase installPhase unpackPhase;
      src = pkgs.fetchurl {
        url = packageInfo.source_url;
        sha256 = hash;
      };
    };
in {
  example = mkPackageFromDb "hello-world";
}