{ stdenv, fetchFromGitHub, automake, autoreconfHook, libtool, fuse, pkgconfig,
  pcre, lz4, xz, zlib, lzo, zstd }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.101";
  name = "${pname}-${version}";

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = https://github.com/vasi/squashfuse;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
    license = "BSD-2-Clause";
  };

  # platforms.darwin should be supported : see PLATFORMS file in src.
  # we could use a nix fuseProvider, and let the derivation choose the OS
  # specific implementation.

  src = fetchFromGitHub {
    owner = "vasi";
    repo  = "squashfuse";
    rev = "371e4bee9caa254d842913df9bdbcc795c5b342c";
    sha256 = "0i9p8r1c128hzy0cwmga1x7q8zk7kw68mh8li5ipfz8zba60d7vz";
  };

	/* src = fetchurl {
	    url = "https://github.com/vasi/squashfuse/archive/${version}.tar.gz";
	    sha256 = "08d1j1a73dhhypbk0q20qkrz564zpmvkpk3k3s8xw8gd9nvy2xa2";
	  }; */

  patches = [ ./0003-introduice-to-squashfuse.pc.in.patch ];

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];
}
