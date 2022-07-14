#!/bin/sh
# vim: set tabstop=2 expandtab softtabstop=2 shiftwidth=2 autoindent :

set -e

if [ "$1" = 'xinetd' ]; then

  if [ ! -e /home/nethack/dgldir/dgamelaunch.db ]; then
    echo "Copying /home/nethack/dgldir."
    cp -a /home/nethack/dgldir.orig/* /home/nethack/dgldir/
  fi

  if [ ! -e /home/nethack/nh366/var/perm ]; then
    echo "Copying /home/nethack/nh366/var."
    cp -a /home/nethack/nh366/var.orig/* /home/nethack/nh366/var/
  fi

  chown -R games:games /home/nethack/dgldir /home/nethack/nh366/var
  chmod -R o-rwx /home/nethack/dgldir /home/nethack/nh366/var

  echo "Starting $@"
fi

exec "$@"
