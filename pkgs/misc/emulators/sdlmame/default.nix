{ stdenv, fetchurl, makeWrapper, pkgconfig, python3, alsaLib, qt5, lua5_3,
  SDL2, fontconfig, freetype, SDL2_ttf, sqlite, libjpeg, expat, flac, openmpi,
  portaudio, portmidi, zlib, mesa, xorg }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.194";
  name    = "sdlmame-${version}";
  mamename = "mame" + replaceStrings ["."] [""] (version);

  src = fetchurl {
      url    = "https://github.com/mamedev/mame/archive/${mamename}.tar.gz";
      sha256 = "07bn7q919hrmqblzi0awmy3f0867pvhgcwscl4r14rqd5nvzmbqz";
    };

  meta = with stdenv.lib; {
    homepage    = http://mamedev.org/;
    description = "Multiple Arcade Machine Emulator + Multi Emulator Super System (MESS)";
    license     = "MAME";
    maintainers = [ maintainers.genesis ];
    platforms   = platforms.linux; # should work on darwin with a little effort.
  };

  nativeBuildInputs = [makeWrapper python3 pkgconfig ];
  buildInputs = [ alsaLib lua5_3 qt5.full SDL2 fontconfig freetype SDL2_ttf
      libjpeg expat flac openmpi portaudio portmidi sqlite zlib mesa ];

  makeFlags = [
        "PTR64=0" # if amd64

        # Disable using bundled libraries
      	"USE_SYSTEM_LIB_EXPAT=1"
      	"USE_SYSTEM_LIB_FLAC=1"
      	"USE_SYSTEM_LIB_JPEG=1"
        "USE_SYSTEM_LIB_LUA=1" # need 5.3.4
      	"USE_SYSTEM_LIB_PORTAUDIO=1"
      	"USE_SYSTEM_LIB_SQLITE3=1"
      	"USE_SYSTEM_LIB_ZLIB=1"
        "USE_SYSTEM_LIB_PORTMIDI=1"

      	# Disable warnings being treated as errors and enable verbose build output
      	"NOWERROR=1"
      	"VERBOSE=1"

        "DEBUG=1"
        "TOOLS=1"
        "OPENMP=1"

        "QT_HOME=${qt5.full}"
        "REGENIE=1"
      ];
}
