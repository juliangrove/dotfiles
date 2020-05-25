{ stdenv }:

stdenv.mkDerivation rec {
  name = "libib";

  src = ./libib.tar.gz;

  passthru = {
    tlType = "run";
    pname = "libib";
  };

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bibtex/bst/libib
    cp libib/li.bst $out/bibtex/bst/libib
  '';

  meta = {
    description = "Custom bibstyle li.bst.";
  };
}
