{ fetchgit, stdenv, makeDesktopItem, curl, enet, openal, pkgconfig, libogg,
  libvorbis, SDL, SDL_image, SDL_mixer, makeWrapper, zlib,
  client ? true, server ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {

  # master branch has legacy (1.2.0.2) protocol 1201 and gcc 6 fix.
  branch = "master";
  name = "assaultcube";

  meta = {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = http://assault.cubers.net;
    license = stdenv.lib.licenses.zlib;
  };

  #sadless , fetchgit seems to refetch all stuff when man switch branch .
  src = fetchgit {
    url = "https://github.com/assaultcube/AC.git";
    rev = "9f537b0876a39d7686e773040469fbb1417de18b";
    branchName = "${branch}";
    #sha256 = "";
  };

  # ${branch} not accepted as a value ?
  patches = [ ./assaultcube-next.patch ];

  nativeBuildInputs = [ pkgconfig ];

  # add optional for server only ?
  buildInputs = [ makeWrapper enet openal SDL SDL_image libogg libvorbis zlib ];

  #makeFlags = [ "CXX=g++" ];

  targets = (optionalString server "server") + (optionalString client " client");

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
    exec = "${name}";
  };

  GAMES_DATADIR = "/share/games/${name}";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/${GAMES_DATADIR}

    cp -r config packages $out/${GAMES_DATADIR}

    # custom script
    substituteAll "${./launcher.sh}" "$out/bin/${name}"
    chmod a+x "$out/bin/${name}"

    if (test -e source/src/ac_client) then
      cp source/src/ac_client $out/bin/
      mkdir -p $out/share/applications
      cp ${desktop}/share/applications/* $out/share/applications
      install -Dpm644 packages/misc/icon.png $out/share/icons/assaultcube.png
      install -Dpm644 packages/misc/icon.png $out/share/pixmaps/assaultcube.png
    fi

    if (test -e source/src/ac_server) then
      cp source/src/ac_server $out/bin/
      ln -s "$out/bin/${name}" "$out/bin/${name}-server"
    fi
    '';
}
