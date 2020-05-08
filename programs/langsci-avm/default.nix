{ stdenv, fetchzip, texlive }:
let
  version = "0.1.0";
in
stdenv.mkDerivation rec {
  name = "langsci-avm-${version}";

  srcs = [
    (
      fetchzip {
        name = "langsci-avm";
        stripRoot = false;
        url = "http://mirrors.ctan.org/macros/latex/contrib/langsci-avm.zip";
        sha256 = "100zk8v606c0wnc8w6j2fr1arws5svyqafqir76saznnpx5d85nj";
      }
    )
    (
      fetchzip {
        name = "l3packages";
        stripRoot = false;
        url = "http://mirrors.ctan.org/macros/latex/contrib/l3packages.zip";
        sha256 = "1s4ndzlxfdqj0r3bmqwhn97rpd17yxzy17vi8s6x3d8l4fm407p4";
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