{ fetchgit, stdenv, makeDesktopItem, curl, enet, openal, pkgconfig, libogg,
  libvorbis, SDL, SDL_image, SDL_mixer, makeWrapper, zlib,
  client ? true, server ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {

  branch = "next";
  name = "assaultcube";

  meta = {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = http://assault.cubers.net;
    license = stdenv.lib.licenses.zlib;
  };

  src = fetchgit {
    url = "https://github.com/assaultcube/AC.git";
    rev = "cb51e9f422bd6ea7bb7055602ea2973b01ab88c3";
    branchName = "${branch}";
    #sha256 = "";
  };

  # ${branch} not accepted as a value ?
  patches = [ ./assaultcube-next.patch ];

  # change to nixos behaviour
  GAMES_DATADIR = "/share/games" ;
  SYSTEM_NAME = "linux";
  MACHINE_NAME = "wtf";

  /* preConfigure = ''
    # respect FHS and fix binary name
  	sed -i \
  		-e "/^CUBE_DIR=/d ; 2iCUBE_DIR=$(games_get_libdir)/${name}" \
  		-e "s:bin_unix/\${SYSTEM_NAME}\${MACHINE_NAME}:ac_:" \
  		-e "s:cd \${CUBE_DIR}:cd ${GAMES_DATADIR}/${name}:" \
  		${name}.sh server.sh || die
  ''; */

  nativeBuildInputs = [ pkgconfig ];

  # add optional for server only ?
  buildInputs = [ makeWrapper enet openal SDL SDL_image libogg libvorbis zlib ];

  #makeFlags = [ "CXX=g++" ];

  targets = (optionalString server "server") + (optionalString client "client");

  buildPhase = ''
    BUNDLED_ENET=NO make -C source/src ${targets}
  '';

  desktop = makeDesktopItem {
    name = "AssaultCube";
    desktopName = "AssaultCube";
    comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
    genericName = "First-person shooter";
    categories = "Application;Game;ActionGame;Shooter";
    icon = "assaultcube.png";
    exec = ${name};
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/${GAMES_DATADIR}/${name}

    cp -r config packages $out/${GAMES_DATADIR}/${name}

    if (test -e source/src/ac_client) then
      cp source/src/ac_client $out/bin/
      install -Dpm755 ${name}.sh $out/bin/${name}
      mkdir -p $out/share/applications
      cp ${desktop}/share/applications/* $out/share/applications
      install -Dpm644 packages/misc/icon.png $out/share/icons/assaultcube.png
      install -Dpm644 packages/misc/icon.png $out/share/pixmaps/assaultcube.png
    fi

    if (test -e source/src/ac_server) then
      cp source/src/ac_server $out/bin/
      install -Dpm755 server.sh $out/bin/${name}-server
    fi
    '';
}
