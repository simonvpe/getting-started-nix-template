{ project ? import ./nix {} }:

(project.pixie.overrideAttrs (pixie: {
  nativeBuildInputs = pixie.nativeBuildInputs ++ project.devTools;
  shellHook = pixie.shellHook + ''
    ${project.ci.pre-commit-check}
  '';
})).env

