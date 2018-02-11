{ fetchurl, stdenv, makeWrapper, unzip, libxml2 }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "z88dk";
  version = "1.99B";
  name = "${pname}-${version}";

  src = fetchurl {
      url    = "https://netcologne.dl.sourceforge.net/project/z88dk/z88dk/1.99B/z88dk-src-${version}.zip";
      sha256 = "05kd10wdk4s4bpx55p5f1757cf74aj8m3q6xild692inw9m5v54b";
    };

  meta = with stdenv.lib; {
    homepage    = https://www.z88dk.org;
    description = "z88dk - z80 Development Kit";
    license     = "Clarified-Artistic";
    maintainers = [ maintainers.genesis ];
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ makeWrapper libxml2 ];
}
