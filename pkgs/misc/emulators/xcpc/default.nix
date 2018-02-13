{ stdenv, fetchurl, libdsk, pkgconfig, glib, libXaw, libX11, libXext, lesstif }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "xcpc";
  name = "xcpc-${version}";
  version = "20070122";

  src = fetchurl {
    url = "https://versaweb.dl.sourceforge.net/project/xcpc/xcpc/xcpc-20070122/xcpc-20070122.tar.gz";
    sha256 = "0hxsbhmyzyyrlidgg0q8izw55q0z40xrynw5a1c3frdnihj9jf7n";
  };

  meta = {
    description = "a portable Amstrad CPC 464/664/6128 emulator written in C";
    homepage = https://www.xcpc-emulator.net ;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

  buildInputs = [ pkgconfig glib libdsk libXaw libX11 libXext lesstif];
}
