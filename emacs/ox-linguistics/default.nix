{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ox-linguistics";

  src = fetchFromGitHub {
    owner = "wyleyr";
    repo = "ox-linguistics";
    rev = "3051c7e9faaaab4218fd0941fd953fc61103ae6b";
    sha256 = "0wnr2hpjg011h66blzkm12rb43ddwbwm9qrxcx6vj7nhnn2f4rb7";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp lisp/ox-linguistics.el $out/share/emacs/site-lisp
  '';

  meta = with stdenv.lib; {
    description = "Support for linguistics-style examples in Org mode";
    homepage = https://github.com/wyleyr/ox-linguistics;
    license = licenses.gpl3;
  };
}
