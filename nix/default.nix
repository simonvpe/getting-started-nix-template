{ sources ? import ./sources.nix
}:

let
  pkgs = import sources.nixpkgs {};

  # gitignore.nix
  gitignoreSource = (import sources."gitignore.nix" { inherit (pkgs) lib; }).gitignoreSource;
  src = gitignoreSource ./..;
in
with pkgs; rec {
  inherit pkgs src;

  pixie = pkgs.haskell.packages.ghc865.callPackage ./pixie.nix {};

  # provided by shell.nix
  devTools = [ niv pre-commit cabal2nix ];

  # to be built by github actions
  ci = {
    pre-commit-check = (import sources."pre-commit-hooks.nix").run {
      inherit src;
      hooks = {
        shellcheck.enable = true;
        nixpkgs-fmt.enable = true;
        nix-linter.enable = true;
      };
      # generated files
      excludes = [ "^nix/sources\.nix$" ];
    };

  };
}
