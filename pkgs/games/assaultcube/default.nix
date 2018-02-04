{ fetchgit, stdenv, curl, enet, openal, pkgconfig, libogg, libvorbis, SDL,
  SDL_image, SDL_mixer, makeWrapper, zlib }:

stdenv.mkDerivation rec {

  branch = "next";
  name = "assaultcube-${branch}";

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

  patches = [ ./assaultcube-next.patch ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ makeWrapper enet openal SDL SDL_image libogg libvorbis zlib ];

  #makeFlags = [ "CXX=g++" ];

  buildPhase = ''
    BUNDLED_ENET=NO make -C source/src client
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp source/src/ac_client $out/bin/
  '';

}
