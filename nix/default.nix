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
    cp tatin "$out"
    cp -r APLSource "$out"
    touch "$out/bin/tatin"
    echo "#!/usr/bin/env sh" >> "$out/bin/tatin"
    echo 'INSTALL_DIR="${placeholder "out"}/" ${dyalog}/bin/dyalogscript DYALOG_INITSESSION=1 "${placeholder "out"}/tatin" $@' >> "$out/bin/tatin"
    chmod +x $out/bin/tatin
  '';

  meta = {
    description = "A command-line interface for the Tatin package manager, allowing you to manage APL packages from your terminal";
    homepage    = "https://github.com/Bombardier-C-Kram/TatinCLI";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.all;
  };
})
