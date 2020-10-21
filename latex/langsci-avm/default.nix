{ stdenv, fetchzip, texlive }:

stdenv.mkDerivation rec {
  name = "langsci-avm-${version}";

  version = "0.1.0";

  srcs = [
    (
      fetchzip {
        name = "langsci-avm";
        stripRoot = false;
        url = "http://mirrors.ctan.org/macros/latex/contrib/langsci-avm.zip";
        sha256 = "0swzndrg3ahyvxn198h9bjv20mwypi12pzff0w8xj5w5cihpwslv";
      }
    )
    (
      fetchzip {
        name = "l3packages";
        stripRoot = false;
        url = "http://mirrors.ctan.org/macros/latex/contrib/l3packages.zip";
        sha256 = "1s15nxwihmansrby9x2k12h9jvaznggxxdm21qfd4b7jxrp1gnq7";
      }
    )
  ];

  passthru = {
    tlType = "run";
    pname = "langsci-avm";
    inherit version;
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildInputs = [ texlive.combined.scheme-small ];

  sourceRoot = ".";

  buildPhase = ''
    cd l3packages/l3packages
    latex xparse.ins
    cd ../../langsci-avm/langsci-avm
    latex langsci-avm.ins
    cd ../../
  '';

  installPhase = ''
    mkdir -p $out/doc/latex/xparse
    cp l3packages/l3packages/xparse.pdf $out/doc/latex/xparse
    mkdir -p $out/tex/latex/xparse
    cp l3packages/l3packages/xparse.sty $out/tex/latex/xparse
    cp l3packages/l3packages/xparse-generic.tex $out/tex/latex/xparse
    mkdir $out/doc/latex/langsci-avm
    cp langsci-avm/langsci-avm/langsci-avm.pdf $out/doc/latex/langsci-avm
    mkdir $out/tex/latex/langsci-avm
    cp langsci-avm/langsci-avm/langsci-avm.sty $out/tex/latex/langsci-avm
  '';

  meta = with stdenv.lib; {
    description = "Attribute-value matrices and feature structures for use in linguistics";
    homepage = https://ctan.org/pkg/langsci-avm;
    license = licenses.lppl13c;
  };
}
