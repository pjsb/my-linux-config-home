#!/bin/bash

# taegliches backup der otrs Datenbank
#
#
#
# Deklarationen
#

NAME="otrs"
DBCONNECT="otrs/otrs@localhost/prod"
REMOTE="root@db-srv02"
VERZEICHNIS="backupdirdaily"
SCHEMAS="otrs"

# VARIABLEN ALLGEMEIN
DATE=$(date +"%y-%m-%d")

# VARIABLEN DBSERVER
FILENAME="$DATE_$NAME"
ORADIR="/opt/oracle/"
EXPORT="$FILENAME.dmp"
LOG="$FILENAME.log"
ZIP="$EXPORT.tar.bz2"

#
# Datenbankexport
# Daten sollen unter /opt/BACKUP/Daily gespeichert werden.
#

CMD_ARGS="$DBCONNECT directory=$VERZEICHNIS schemas=$SCHEMAS dumpfile=$EXPORT logile=$LOG"
ssh ${REMOTE} "expdp $CMD_ARGS"

# Dumpdateien packen mit bzip 2

CMD_ARGS="cd $VERZEICHNIS; tar -cvjf $NAME_$DATE.tar.bz2 $EXPORT $LOG"
ssh ${REMOTE} "CMD_ARGS"
