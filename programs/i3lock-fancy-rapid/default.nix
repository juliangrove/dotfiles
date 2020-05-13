{ stdenv, fetchFromGitHub, xorg, i3lock-color }:

stdenv.mkDerivation rec {
  name = "i3lock-fancy-rapid";

  src = fetchFromGitHub {
    owner = "juliangrove";
    repo = "i3lock-fancy-rapid";
    rev = "23a8dce06d7d34ce2134a184bf6585a2dfd48279";
    sha256 = "1igdx3flj75fvsnw7pcwqnbnm7bhshrcbhpwpsq6vbk8qgndj6xw";
  };

  patchPhase = ''
    sed -i "s|i3lock-color|${i3lock-color}/bin/i3lock-color|g" i3lock-fancy-rapid.c
  '';

  buildInputs = [ xorg.libX11 ];

  installPhase = ''
    mkdir -p $out/bin
    cp i3lock-fancy-rapid $out/bin/
  '';

  meta = {
    description = "A fork of i3lock-fancy-rapid that uses i3lock-color instead of i3lock.";
    homepage = "https://github.com/juliangrove/i3lock-fancy-rapid";
  };
}
