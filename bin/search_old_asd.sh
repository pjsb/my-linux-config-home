#!/bin/sh
find /cygdrive/c/Users/jens/Documents/Ableton/ -name '*.asd' | while read FILE
do
    MASTER=$FILE | sed 's/\.asd//'
	
	if ! [ -f $MASTER ];
	then
		echo $FILE
	fi	
done