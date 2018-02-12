{ stdenv, fetchurl, makeWrapper, pkgconfig, python3, alsaLib, qt5, lua,
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
  };

  # Function to disable a makefile option
  #disable_feature = '' sed -i -e "/^[ 	]*$1.*=/s:^:# :" makefile '';
  #disable_feature = feature: (''sed -i -e "/^[ 	]*${feature}.*=/s:^:# :" makefile'');

  # Function to enable a makefile option
  #enable_feature = '' sed -i -e "/^#.*$1.*=/s:^#[ 	]*::"  makefile '';
  /* enable_feature = feature: (''sed -i -e "/^#.*${feature}.*=/s:^#[  ]*::"  makefile''); */

#    /* bgfx needs X ${disable_feature "NO_X11"}*/
  /* configurePhase = ''
    set +x
  	# Disable using bundled libraries
  	"USE_SYSTEM_LIB_EXPAT"}
  	"USE_SYSTEM_LIB_FLAC"}
  	"USE_SYSTEM_LIB_JPEG"}
    "USE_SYSTEM_LIB_LUA"}
  	"USE_SYSTEM_LIB_PORTAUDIO"}
  	"USE_SYSTEM_LIB_SQLITE3"}
  	"USE_SYSTEM_LIB_ZLIB"}

  	# Disable warnings being treated as errors and enable verbose build output
  	"NOWERROR"}
  	"VERBOSE"}

    "PTR64"} # #if amd64
    "DEBUG"} # ? use debug &&
    "TOOLS"} # ? use tools &&

    "OPENMP"} # ? use openmp &&
    "USE_SYSTEM_LIB_PORTMIDI"}

    sed -i \
      -e 's/-Os//' \
      -e '/^\(CC\|CXX\|AR\) /s/=/?=/' \
      3rdparty/genie/build/gmake.linux/genie.make
    ''; */

  nativeBuildInputs = [makeWrapper python3 pkgconfig ];
  buildInputs = [ alsaLib lua qt5.full SDL2 fontconfig freetype SDL2_ttf
      libjpeg expat flac openmpi portaudio portmidi zlib mesa ];

  makeFlags =
      let
        arch = head (splitString "-" stdenv.system);
      in [
        /* "ARCHITECTURE=${arch}"
        "TARGETOS=linux" */
        "PTR64=1" # #if amd64

        # Disable using bundled libraries
      	"USE_SYSTEM_LIB_EXPAT=1"
      	"USE_SYSTEM_LIB_FLAC=1"
      	"USE_SYSTEM_LIB_JPEG=1"
        "USE_SYSTEM_LIB_LUA=0" # need 5.3.4
      	"USE_SYSTEM_LIB_PORTAUDIO=1"
      	"USE_SYSTEM_LIB_SQLITE3=1"
      	"USE_SYSTEM_LIB_ZLIB=1"
        "USE_SYSTEM_LIB_PORTMIDI=1"

      	# Disable warnings being treated as errors and enable verbose build output
      	"NOWERROR=1"
      	"VERBOSE=1"

        "DEBUG=1" # ? use debug &&
        "TOOLS=1" # ? use tools &&
        "OPENMP=1" # ? use openmp &&

        "QT_HOME=${qt5.full}"
        "REGENIE=1"
      ];

}
