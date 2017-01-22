#!/bin/bash

EXCLUDE=""
if [ -n "$2" ]
  then
  EXCLUDE="--exclude=$2"
  echo "Excluding: $EXCLUDE"
fi

mount tmpport
echo "Updating..."
if [ -z ${1} ] || [ "${1}" != "nofetch" ] 
    then
    eix-remote update && eix-update && eix-sync
fi
emerge -uDNa $EXCLUDE @world && emerge --depclean -a && revdep-rebuild
umount tmpport
echo "Update successful!"
