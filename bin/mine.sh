#!/bin/bash

# set the worker name and password for your mining pool
WORKER="pjsb"
PASS="kwacha09@"

# see cgminer and bfgminer readme for details, choose one
# OPTS="--disable-gpu --quiet --algo auto"
# OPTS="--quiet --algo auto"
# OPTS="--device=0"
# OPTS="--quiet -w 128 -g 1"
# OPTS="--quiet -I 14"
OPTS="--compact --gpu-fan 100 --auto-gpu --intensity 14 --temp-overheat 90 --temp-cutoff 100 --temp-target 80 --verbose"

# enter pool URLS in format URL:port
URL1="stratum+tcp://mint.bitminter.com:3333"
URL2="stratum+tcp://mint.bitminter.com:3333"
URL3="stratum+tcp://mint.bitminter.com:3333"


# get full path to miner, uncomment the miner you want
# CMD=`which cgminer`
CMD=`which bfgminer`

##############################
# no need to edit below here #
##############################

# formart worker strings
S1="-o $URL1 -O $WORKER":"$PASS"
S2="-o $URL2 -O $WORKER":"$PASS"
S3="-o $URL3 -O $WORKER":"$PASS"

rm -i /root/*.bin

# concatenate command to run
RUN="$CMD $OPTS $S1 $S2 $S3"

# echo instead of running, if for testing purposes
# echo "$RUN"

$RUN
