#!/bin/sh
# original scripts are very awful

CUBE_DIR=/share/games/assaultcube

case "$0" in
  assaultcube-server)
    CUBE_OPTIONS="-Cconfig/servercmdline.txt"
    BINARYPATH = /bin/ac_server
    ;;
  assaultcube)
    CUBE_OPTIONS="--home=${HOME}/.assaultcube/v1.2next --init"
    BINARYPATH = /bin/ac_client
    ;;
esac

cd $CUBE_DIR
exec "${BINARYPATH}" ${CUBE_OPTIONS} "$@"
