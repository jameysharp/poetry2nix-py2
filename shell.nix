{ sources ? import nix/sources.nix }:

let
  pkgs = import nix/pkgs.nix { inherit sources; };
in pkgs.mkShell {
  packages = [
    pkgs.python27
    pkgs.poetry
  ];
}
