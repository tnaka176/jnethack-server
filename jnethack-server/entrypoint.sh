#!/bin/bash
# vim: set tabstop=2 expandtab softtabstop=2 shiftwidth=2 autoindent :

set -e

if [ "$1" == 'jnethack' ]; then

  # initialize nethack data
  if [ ! -e /nh366/var/perm ]; then
    echo "Copying /nh366/var."
    cp -a /nh366/var.orig/* /nh366/var/
  fi
  chown -R games:games /nh366/var
  chmod -R o-rwx /nh366/var

  # if TERM=dumb, force set vt100
  if [ -z $TERM ] || [ $TERM == "dumb" ]; then
    export TERM=vt100
  fi

  # credential disable
  if [ ${GOTTY_CREDENTIAL} == "disabled" ]; then
    export -n GOTTY_CREDENTIAL
  fi

  # set PATH
  PATH="$PATH:/nh366"

  /usr/local/bin/gotty $1

fi

exec "$@"
