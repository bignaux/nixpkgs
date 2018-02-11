{ stdenv
, fetchurl, qmake
, makeWrapper, minizip, phonon
, qtbase, qtsvg
, qtmultimedia, qtwebkit
, qttranslations, qtxmlpatterns, rsync
, SDL2, xwininfo, zlib
, utillinux #colrm
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "qmc2-${version}";
  version = "0.192";

  meta = with stdenv.lib; {
    description = "Frontend for MAME/MESS";
    homepage = http://qmc2.batcom-it.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
  };

  src = fetchurl {
      url =  "https://netix.dl.sourceforge.net/project/qmc2/qmc2/0.192/qmc2-0.192.tar.gz";
      #url = "mirror://sourceforge/projects/qmc2/files/qmc2/${version}/${name}.tar.gz/download";
      sha256 = "1sfvaycl0lqhzpn21x46jlj1chvyzgwbc80nrd56zcfsqc10718m";
    };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ minizip phonon qtbase qtsvg qtmultimedia qtwebkit
                  qttranslations qtxmlpatterns rsync SDL2 xwininfo zlib utillinux];
  enableParallelBuilding = true;
  makeFlags = [ "DESTDIR=$(out)" "PREFIX=$(out)" "DATADIR=/share/games" "SYSCONFDIR=/etc" ];


  # games/applications/qmc2-sdlmame.desktop
}
