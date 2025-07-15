{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  };
  outputs = { self, nixpkgs }:
    let
      forAllSystems = with nixpkgs.lib; f: foldAttrs mergeAttrs { }
        (map (s: { ${s} = f s; }) systems.flakeExposed);
    in
    {
      devShell = forAllSystems
        (system:
          let pkgs = nixpkgs.legacyPackages.${system}; in
          pkgs.mkShell rec {
            packages = with pkgs; [
              nim
              nimlangserver
              nimble
              nph
              terser
            ];
            buildInputs = with pkgs; [
              sqlite
            ];
            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
            '';
          });
    };
}

