#!/bin/bash
PROJECT_DIR=/home/jpeters/Projekte/misa2
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot relations-ws "$PROJECT_DIR/misa/relations/relations-ws/target/relations-ws.war"
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot rm-ws "$PROJECT_DIR/rm/rm/rm-ws/target/rm-ws-3.0.0-SNAPSHOT.war"
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot dlm-ws "$PROJECT_DIR/dlm/dlm/target/dlm-ws-1.0.0-SNAPSHOT.war"
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot servicegateway-ws "$PROJECT_DIR/misa/servicegateway/servicegateway-ws/target/servicegateway-ws-2.0.0-SNAPSHOT.war"

JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 ~/GlassFish_Server3/bin/asadmin --host 192.168.255.233 --port 38199 deploy --force --contextroot epm "$PROJECT_DIR/std/build/ear/target/epm.ear"

#/home/jpeters/GlassFish_Payara411_164/bin/asadmin deploy --force --contextroot relations-ws "$PROJECT_DIR/misa/relations/relations-ws/target/relations-ws.war
#/home/jpeters/GlassFish_Payara411_164/bin/asadmin deploy --force --contextroot rm-ws "$PROJECT_DIR/rm/rm/rm-ws/target/rm-ws-3.0.0-SNAPSHOT.war
#/home/jpeters/GlassFish_Payara411_164/bin/asadmin deploy --force --contextroot dlm-ws "$PROJECT_DIR/dlm/dlm/target/dlm-ws-1.0.0-SNAPSHOT.war
#/home/jpeters/GlassFish_Payara411_164/bin/asadmin deploy --force --contextroot servicegateway-ws "$PROJECT_DIR/misa/servicegateway/servicegateway-ws/target/servicegateway-ws-2.0.0-SNAPSHOT.war

#/home/jpeters/GlassFish_Payara411_171/bin/asadmin deploy --force --contextroot relations-ws "$PROJECT_DIR/misa/relations/relations-ws/target/relations-ws.war
#/home/jpeters/GlassFish_Payara411_171/bin/asadmin deploy --force --contextroot rm-ws "$PROJECT_DIR/rm/rm/rm-ws/target/rm-ws-3.0.0-SNAPSHOT.war
#/home/jpeters/GlassFish_Payara411_171/bin/asadmin deploy --force --contextroot dlm-ws "$PROJECT_DIR/dlm/dlm/target/dlm-ws-1.0.0-SNAPSHOT.war
#/home/jpeters/GlassFish_Payara411_171/bin/asadmin deploy --force --contextroot servicegateway-ws "$PROJECT_DIR/misa/servicegateway/servicegateway-ws/target/servicegateway-ws-2.0.0-SNAPSHOT.war
