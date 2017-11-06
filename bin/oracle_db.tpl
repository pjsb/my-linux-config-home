####################################################################
## IMPORTANT NOTE: This file contains plain text passwords and    ##
## should be secured to have read permission only by oracle user  ##
## or db administrator who owns this installation.                ##
####################################################################

#-------------------------------------------------------------------------------
# Do not change the following system generated value.
#-------------------------------------------------------------------------------
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v12.1.0

#-------------------------------------------------------------------------------
# Specify the installation option: INSTALL_DB_SWONLY (Software only),
#   INSTALL_DB_AND_CONFIG or UPGRADE_DB
#-------------------------------------------------------------------------------
oracle.install.option=INSTALL_DB_AND_CONFIG

ORACLE_HOSTNAME=${HOSTNAME}
UNIX_GROUP_NAME=${GROUP}
SELECTED_LANGUAGES=en,de

INVENTORY_LOCATION=${INVENTORY_DIR}
ORACLE_BASE=${INSTALL_DIR}
ORACLE_HOME=${ORACLE_HOME}

oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=${DATA_DIR}

#-------------------------------------------------------------------------------
# Specify the installation edition of the component.
#-------------------------------------------------------------------------------
oracle.install.db.InstallEdition=EE

#------------------------------------------------------------------------------
# The DBA_GROUP is the OS group which is to be granted OSDBA privileges.
#-------------------------------------------------------------------------------
oracle.install.db.DBA_GROUP=oracle

#------------------------------------------------------------------------------
# The OPER_GROUP is the OS group which is to be granted OSOPER privileges.
# The value to be specified for OSOPER group is optional.
#------------------------------------------------------------------------------
oracle.install.db.OPER_GROUP=oracle

#------------------------------------------------------------------------------
# The BACKUPDBA_GROUP is the OS group which is to be granted OSBACKUPDBA privileges.
#------------------------------------------------------------------------------
oracle.install.db.BACKUPDBA_GROUP=oracle

#------------------------------------------------------------------------------
# The DGDBA_GROUP is the OS group which is to be granted OSDGDBA privileges.
#------------------------------------------------------------------------------
oracle.install.db.DGDBA_GROUP=oracle

#------------------------------------------------------------------------------
# The KMDBA_GROUP is the OS group which is to be granted OSKMDBA privileges.
#------------------------------------------------------------------------------
oracle.install.db.KMDBA_GROUP=oracle


###############################################################################
#                        Database Configuration Options                       #
###############################################################################
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE

oracle.install.db.config.starterdb.globalDBName=orcl
oracle.install.db.config.starterdb.SID=orcl
oracle.install.db.config.starterdb.characterSet=AL32UTF8

oracle.install.db.config.starterdb.memoryOption=true

oracle.install.db.config.starterdb.memoryLimit=2048

###############################################################################
# Passwords can be supplied for the following four schemas in the starter     #
# database:                                                  						      #
#   SYS                                                                       #
#   SYSTEM                                                                    #
#   DBSNMP (used by Enterprise Manager)                                       #
#                                                                             #
# Same password can be used for all accounts (not recommended)                #
###############################################################################

#------------------------------------------------------------------------------
# This variable holds the password that is to be used for all schemas
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.password.ALL=
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.DBSNMP=

#------------------------------------------------------------------------------
# My Oracle Support Account
#------------------------------------------------------------------------------
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=

#------------------------------------------------------------------------------
# Specify whether user doesn't want to configure Security Updates.
#------------------------------------------------------------------------------
DECLINE_SECURITY_UPDATES=true

#------------------------------------------------------------------------------
# Specify the Proxy server
#------------------------------------------------------------------------------
# PROXY_HOST= PROXY_PORT= PROXY_USER= PROXY_PWD=

###############################################################################
# SPECIFY RECOVERY OPTIONS                                 	                  #
###############################################################################
oracle.install.db.config.starterdb.enableRecovery=false

#-------------------------------------------------------------------------------
# Specify the type of storage: FILE_SYSTEM_STORAGE, ASM_STORAGE
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE

#-------------------------------------------------------------------------------
# Specify the recovery location.
# requires oracle.install.db.config.starterdb.storage=FILE_SYSTEM_STORAGE
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=

#-------------------------------------------------------------------------------
# Specify the existing ASM disk groups to be used for storage.
# requires oracle.install.db.config.starterdb.storageType=ASM_STORAGE
#-------------------------------------------------------------------------------
oracle.install.db.config.asm.diskGroup=
oracle.install.db.config.asm.ASMSNMPPassword=
