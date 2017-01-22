#!/bin/bash
JAVA6=$(cygpath -ua "D:\java\jdk1.6.0_25")
JAVA7=$(cygpath -ua "C:\PROGRA~1\Java\jdk1.7.0_03")

if [ "${1}" == "6" ]
then
	JAVA_HOME=$JAVA6
else
	JAVA_HOME=$JAVA7
fi

IFS=':'
CYGWIN=nodosfilewarning
PATHNEW=''
for A in ${PATH}
do
	
	if [[ "$A" != *"Java"* || "$A" != *"jdk"* || "$A" == *"java"* ]]	
	then
		PATHNEW=$PATHNEW:"$A"
	fi
	
done
export PATH=$JAVA_HOME/bin$PATHNEW
export JAVA_HOME="$JAVA_HOME"

# Output
echo -e "JAVA_HOME\t" $JAVA_HOME
echo -e "PATH"
for A in ${PATH}
do
	echo "${A}"
done