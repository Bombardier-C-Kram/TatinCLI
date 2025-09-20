{
  lib,
  stdenv,
  dyalog
}: stdenv.mkDerivation (finalAttrs: {
  pname = "TatinCLI";
  version = "rolling";
  src = ./..;

  buildInputs = [
    (dyalog.override { acceptLicense = true; })
  ];

  buildPhase = ''
    mkdir -p "$out/bin"
    cp tatin "$out/bin"
    sed -i 1d "$out/bin/tatin"
    sed -i '1s/^/#!${lib.escape ["/"] "${dyalog}/bin/dyalogscript DYALOG_INITSESSION=1"}\n/' "$out/bin/tatin"
    chmod +x $out/bin/tatin

    cp -r APLSource "$out"
    export INSTALL_DIR="$out"
  '';

  meta = {
    description = "A command-line interface for the Tatin package manager, allowing you to manage APL packages from your terminal";
    homepage    = "https://github.com/Bombardier-C-Kram/TatinCLI";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.all;
  };
})
