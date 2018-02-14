{ stdenv, fetchFromGitHub, libpng, pkgconfig, SDL, freetype, zlib, mesa }:

stdenv.mkDerivation rec {

  pname = "caprice32";
  version = "02102017";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ColinPitrat";
    repo  = "caprice32";
    rev = "53de69543300f81af85df32cbd21bb5c68cab61e";
    sha256 = "12yv56blm49qmshpk4mgc802bs51wv2ra87hmcbf2wxma39c45fy";
  };

  patchPhase = "substituteInPlace cap32.cfg --replace /usr/local $out";

  meta = with stdenv.lib; {
    description = "a complete emulation of CPC464, CPC664 and CPC6128";
    homepage = https://github.com/ColinPitrat/caprice32 ;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng SDL freetype zlib ];
  makeFlags = [ "GIT_HASH=$(src.rev)" "DESTDIR=$(out)" "prefix=/"];
}
