{ fetchurl, stdenv, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "z88dk";
  version = "1.99B";
  name = "${pname}-${version}";

  src = fetchurl {
      url    = "mirror://sourceforge/projects/z88dk/files/z88dk/1.99B/z88dk-src-${version}.zip";
      sha256 = "5042db522fe48fd7f9f11a73168e23f37debe327d3da219d7792b8b3cbee4d72";
    };

  meta = with stdenv.lib; {
    homepage    = https://www.z88dk.org;
    description = "z88dk - z80 Development Kit";
    license     = "Clarified-Artistic";
    maintainers = [ maintainers.genesis ];
  };

  #nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ makeWrapper ];
}
