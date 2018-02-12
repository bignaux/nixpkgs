{ stdenv, fetchurl }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "libdsk";
  name = "libdsk-${version}";
  version = "1.5.8";

  src = fetchurl {
    url = "http://www.seasip.info/Unix/LibDsk/${name}.tar.gz";
    sha256 = "1fdypk6gjkb4i2ghnbn3va50y69pdym51jx3iz9jns4636z4sfqd";
  };

  meta = {
    description = "a library for accessing discs and disc image files";
    homepage = http://www.seasip.info/Unix/LibDsk/ ;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
