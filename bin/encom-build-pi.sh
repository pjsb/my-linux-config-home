#!/bin/bash

OPTS="-DskipTests=true -DT2C"

cd /home/jpeters/Projekte/misa2/pltf/bundle
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/pltf-flex/web-src
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/misa/project-parent
mvn $OPTS clean install

cd ~/Projekte/misa2/misa/http-client
mvn $OPTS clean install

cd ~/Projekte/misa2/misa/pi-sdk
mvn $OPTS clean install

cd ~/Projekte/misa2/misa/misa-sdk
mvn $OPTS clean install

cd ~/Projekte/misa2/misa/serviceregistry-client
mvn $OPTS clean install

cd ~/Projekte/misa2/misa/relations
mvn $OPTS clean install

cd ~/Projekte/misa2/misa/servicegateway
mvn $OPTS clean install

cd /home/Projekte/misa2/pltf/dto-adapter
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/Projekte/misa2/pltf/epm-ejb
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/Projekte/misa2/pltf-flex/framework
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/Projekte/misa2/pltf-flex/core
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/rm/rm
mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/rm/rm-flex
mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/dlm/dlm
mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/dlm/dlm-flex
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install

cd /home/jpeters/Projekte/misa2/std/build
JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install
