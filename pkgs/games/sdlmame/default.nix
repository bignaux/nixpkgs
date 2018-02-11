{ stdenv, fetchurl, makeWrapper, pkgconfig, python3, alsaLib, qt5, lua,
  SDL2, fontconfig, freetype, SDL2_ttf, sqlite, libjpeg, expat, flac, openmpi,
  portaudio, portmidi, zlib, xorg }:

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
  disable_feature = feature: ('' sed -i -e "/^[ 	]*$${feature}.*=/s:^:# :" makefile '');

  # Function to enable a makefile option
  #enable_feature = '' sed -i -e "/^#.*$1.*=/s:^#[ 	]*::"  makefile '';
  enable_feature = feature: (''sed -i -e "/^#.*${feature}.*=/s:^#[  ]*::"  makefile'');

  configurePhase = ''
    set +x
  	# Disable using bundled libraries
  	$enable_feature USE_SYSTEM_LIB_EXPAT
  	"$enable_feature" USE_SYSTEM_LIB_FLAC
  	"$enable_feature" USE_SYSTEM_LIB_JPEG
    # Use bundled lua for now to ensure correct compilation (ref. b.g.o #407091)
    "$enable_feature" USE_SYSTEM_LIB_LUA
  	"$enable_feature" USE_SYSTEM_LIB_PORTAUDIO
  	"$enable_feature" USE_SYSTEM_LIB_SQLITE3
  	"$enable_feature" USE_SYSTEM_LIB_ZLIB

  	# Disable warnings being treated as errors and enable verbose build output
  	"$enable_feature" NOWERROR
  	"$enable_feature" VERBOSE

    #if amd64  "$enable_feature" PTR64
    "$enable_feature" DEBUG # ? use debug &&
    "$enable_feature" TOOLS # ? use tools &&
    "$disable_feature" NO_X11 # bgfx needs X
    "$enable_feature" OPENMP # ? use openmp &&
    "$enable_feature" USE_SYSTEM_LIB_PORTMIDI

    sed -i \
      -e 's/-Os//' \
      -e '/^\(CC\|CXX\|AR\) /s/=/?=/' \
      3rdparty/genie/build/gmake.linux/genie.make
    '';

  makeFlags = [ "REGENIE=1" ];
  nativeBuildInputs = [makeWrapper  python3 pkgconfig];
  BuildInputs = [ alsaLib qt5 lua SDL2 fontconfig freetype SDL2_ttf sqlite
    libjpeg expat flac openmpi portaudio portmidi zlib xorg ];
}
