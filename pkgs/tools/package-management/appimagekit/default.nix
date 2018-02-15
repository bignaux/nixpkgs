{ stdenv, fetchFromGitHub, cmake, cairo, fuse, inotify-tools, openssl,
  pkgconfig, pcre, zlib, lzma, libpthreadstubs, glibc, which,
  squashfuse, squashfsTools, gtest, glib, libarchive, autoconf, automake, libtool, wget, xz, git}:

# squashfsTools squashfs-tool
with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "appimagekit";
  version = "20170106";
  name = "${pname}-${version}";

  meta = {
    description = "Package desktop applications as AppImages that run on common Linux-based operating systems";
    homepage = http://appimage.org;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "AppImage";
    repo  = "AppImageKit";
    fetchSubmodules = true; # for sanitizers-cmake
    rev = "88400e4975cd3fb1270e5a6352a7180195dfae83";
    sha256 = "1ix6vxii8al0g7cljdls2hs2y0prqwrzibbkhakngvq7si258g64";
  };

  /* src = fetchurl {
    url = "https://github.com/AppImage/AppImageKit/archive/${version}.tar.gz";
    sha256 = "0s1macf2xhaph3h6hsxj1dc9lgcgm858hsc2jqbsfb5d6wl51n3a";
  }; */

  /* #3382: "unable to get local issuer certificate" problem)  */
  GIT_SSL_CAINFO = /etc/ssl/certs/ca-certificates.crt;

  # no DUSE_SYSTEM_SQUASHFUSE, need git + fuse
  nativeBuildInputs = [ autoconf automake cairo cmake gtest glib libtool
    libarchive openssl pkgconfig pcre inotify-tools fuse libpthreadstubs
    squashfsTools squashfuse zlib lzma glib wget xz git glibc which];

  NIX_LDFLAGS = "-lpthread";
  cmakeFlags = [
    "-DUSE_SYSTEM_XZ=1"
    "-DUSE_SYSTEM_INOTIFY_TOOLS=1"
    "-DUSE_SYSTEM_LIBARCHIVE=1"
    "-DUSE_SYSTEM_GTEST=1"
    "--trace"
  ];

  # add optional for server only ?
  /* buildInputs = [ makeWrapper openal SDL SDL_image libogg libvorbis zlib ]; */

  #makeFlags = [ "CXX=g++" ];
/*
  targets = (optionalString server "server") + (optionalString client " client");
  buildPhase = ''
    make -C source/src ${targets}
  ''; */

  /* desktop = makeDesktopItem {
    name = "appimagekit";
    desktopName = "appimagekit";
    comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
    genericName = "First-person shooter";
    categories = "Application;Game;ActionGame;Shooter";
    icon = "appimagekit.png";
    exec = "${pname}";
  }; */

  /* gamedatadir = "/share/games/${pname}"; */

  /* installPhase = ''

    bindir=$out/bin

    mkdir -p $bindir $out/$gamedatadir

    cp -r config packages $out/$gamedatadir

    # install custom script
    substituteAll ${./launcher.sh} $bindir/appimagekit
    chmod +x $bindir/appimagekit

    if (test -e source/src/ac_client) then
      cp source/src/ac_client $bindir
      mkdir -p $out/share/applications
      cp ${desktop}/share/applications/* $out/share/applications
      install -Dpm644 packages/misc/icon.png $out/share/icons/appimagekit.png
      install -Dpm644 packages/misc/icon.png $out/share/pixmaps/appimagekit.png
    fi

    if (test -e source/src/ac_server) then
      cp source/src/ac_server $bindir
      ln -s $bindir/${pname} $bindir/${pname}-server
    fi
    ''; */
}
