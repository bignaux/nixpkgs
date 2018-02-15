{ fetchFromGitHub, stdenv, makeWrapper, unzip, libxml2, m4 }:

stdenv.mkDerivation rec {

  pname = "z88dk";
  version = "20170217";
  rev = "49a7c6032b2675af742f5b0b3aa5bd5260bdd814";
  short_rev = "${builtins.substring 0 7 rev}";
  name = "${pname}-${version}-${short_rev}";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo  = "z88dk";
    fetchSubmodules = true; # for uthash + UNIXem
    rev = "${rev}";
    sha256 = "0jd312jcl0rqn15c2nbllpqz2x67hwvkhlz2smbqjyv8mrbhqbcc";
  };

  meta = with stdenv.lib; {
    homepage    = https://www.z88dk.org;
    description = "z88dk - z80 Development Kit";
    license     = "Clarified-Artistic";
    maintainers = [ maintainers.genesis ];
  };

  postPatch =
  ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/sh@${stdenv.shell}@' -i '{}' ';'
    find . -name '*.sh' -exec chmod +x {} \;
    #./build.sh -c  # we dont rely on this NIH script :
    make clean
    mkdir -p $(out)/bin
    export PATH="$PWD/bin:$PATH" # needed to have zcc in testsuite
    export ZCCCFG=$PWD/lib/config/
  '';

/* git_rev = $(shell git rev-parse --short HEAD)
git_count = $(shell git rev-list --count HEAD) */
# "version=$(version)

  makeFlags = [ "DESTDIR=$(out)" "prefix=/"
      "git_rev=$(short_rev)" ];
  nativeBuildInputs = [ makeWrapper unzip m4 ];
  buildInputs = [ libxml2 ];

  #installTargets = "";
}
