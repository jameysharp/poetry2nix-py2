{ pkgs ? import ../nix/pkgs.nix {} }:

let
  app = pkgs.poetry2nix.mkPoetryApplication {
    python = pkgs.python27;
    projectDir = ./.;
  };
in app
