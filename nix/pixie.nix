{ mkDerivation, base, stdenv }:
mkDerivation {
  pname = "pixie";
  version = "0.0.0";
  src = /home/starlord/projects/pixie;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
