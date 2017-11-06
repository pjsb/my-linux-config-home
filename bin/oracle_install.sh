#!/bin/sh

############################### TODO ########################################
# Kernel optimized install check e.g. supported OS Fallback:
# - stage/cvu/cv/admin/cvu_config
# - CV_ASSUME_DISTID=OEL5
# --> grep -B 5 KERNEL_VER ./stage/cvu/cvu_prereq.xml
##############################################################################

if [ $# -neq 7 ]
  then
    echo "USAGE: ./oracle_install.sh <UNIX_USER> <UNIX_GROUP> <INSTALLER_DIR> <INSTALL_DIR> <INVENTORY_DIR> <DATA_DIR> <HOSTNAME>"
    exit 1
fi

# PARAMS
USER=$1
GROUP=$2
INSTALLER_DIR=$3
INSTALL_DIR=$4
INVENTORY_DIR=$5
DATA_DIR=$6
HOSTNAME=$7
ORACLE_HOME="$INSTALL_DIR/product/12.1.0/db_1"

# INTERNAL
RESPONSE_FILE_TPL="./oracle_db.tpl"
RESPONSE_FILE="./oracle_db.rsp"

# CREATE DIRECTORIES
mkdir "$INSTALL_DIR" "$INVENTORY_DIR" "$DATA_DIR"
chown $USER>:$GROUP "$INSTALL_DIR" "$INVENTORY_DIR" "$DATA_DIR"

# SET GLOBAL ENV
echo "export ORACLE_HOME=$ORACLE_HOME" >> /etc/profile

# CREATE RESPONSE INSTALL FILE
cp "$RESPONSE_FILE_TPL" "$RESPONSE_FILE"
sed -i "s/${USER}/$USER/" $RESPONSE_FILE
sed -i "s/${GROUP}/$GROUP/" $RESPONSE_FILE
sed -i "s/${INSTALLER_DIR}/$INSTALLER_DIR/" $RESPONSE_FILE
sed -i "s/${INSTALL_DIR}/$INSTALL_DIR/" $RESPONSE_FILE
sed -i "s/${INVENTORY_DIR}/$INVENTORY_DIR/" $RESPONSE_FILE
sed -i "s/${DATA_DIR}/$DATA_DIR/" $RESPONSE_FILE
sed -i "s/${HOSTNAME}/$HOSTNAME/" $RESPONSE_FILE
sed -i "s/${ORACLE_HOME}/$ORACLE_HOME/" $RESPONSE_FILE

su -c "$INSTALL_DIR/runInstaller -silent -waitForCompletion -responseFile ./oracle_db.rsp" $USER
