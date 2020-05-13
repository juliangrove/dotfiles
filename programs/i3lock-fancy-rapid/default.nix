{ stdenv, fetchFromGitHub, xorg, i3lock-color }:

stdenv.mkDerivation rec {
  rev = "e9f7db176325fc92a7c90d040ddf283074957595";

  name = "i3lock-fancy-rapid";

  src = fetchFromGitHub {
    owner = "juliangrove";
    repo = "i3lock-fancy-rapid";
    inherit rev;
    sha256 = "0v37lzzawn26w7dx07ppba74yrl1cbgja9sxrc43mxyfl4l0nm4n";
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
