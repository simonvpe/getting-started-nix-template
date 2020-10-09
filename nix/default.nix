{ sources ? import ./sources.nix
}:

let
  config = {
    packageOverrides = super: rec {
      haskell = super.haskell // {
        pixie = super.callCabal2nix "pixie" src;
      };
    };
  };

  pkgs = import sources.nixpkgs { inherit config; };

  # gitignore.nix
  gitignoreSource = (import sources."gitignore.nix" { inherit (pkgs) lib; }).gitignoreSource;

  src = gitignoreSource ./..;


in
with pkgs; {
  inherit pkgs src;

  # provided by shell.nix
  devTools = {
    inherit niv pre-commit;
  };

  # to be built by github actions
  ci = {
    out = {
      shell = compilerSet.shellFor {
        packages = p: [ p.pixie ];
        buildInputs = [ compilerSet.cabal-install ];
      };
    };
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
