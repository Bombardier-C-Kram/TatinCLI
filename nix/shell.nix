{ pkgs, tatinCLI, dyalog }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.bqn
    tatinCLI
    dyalog
  ];

  shellHook = ''
  '';
}
