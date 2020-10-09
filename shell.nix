{ project ? import ./nix {} }:

(project.pixie.overrideAttrs (pixie: {
  nativeBuildInputs = (pixie.nativeBuildInputs or []) ++ project.devTools;
  shellHook = (pixie.shellHook or "") + ''
    echo HELO
    ${project.ci.pre-commit-check.shellHook}
  '';
})).env

