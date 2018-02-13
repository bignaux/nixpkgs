{ stdenv, fetchurl, libpng, pkgconfig, SDL, freetype, zlib }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "caprice32";
  name = "${pname}-${version}";
  version = "4.4.0";

  src = fetchurl {
    url = "https://github.com/ColinPitrat/caprice32/archive/v${version}.tar.gz";
    sha256 = "1y2gix3lf096f2k4dhijh08v7pg81kydwgh76wn3j4f0xk031cq0";
  };

  meta = {
    description = "a complete emulation of CPC464, CPC664 and CPC6128";
    homepage = https://github.com/ColinPitrat/caprice32 ;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng SDL freetype zlib ];
  /* makeFlags = [
      "DEBUG=TRUE"
      "WITHOUT_GL=TRUE"
      "ARCH=linux"
  ]; */
}
