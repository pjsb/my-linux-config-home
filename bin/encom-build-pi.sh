#!/bin/bash
OPTS="-DskipTests=true -DT2C"

build7() {
  cd "$1"
  JAVA_HOME=/opt/oracle-jdk-bin-1.7.0.079 mvn $OPTS clean install
}

build() {
  cd "$1"
  mvn $OPTS clean install
}

build /home/jpeters/Projekte/misa2/misa/project-parent
build /home/jpeters/Projekte/misa2/misa/http-client
build7 /home/Projekte/misa2/pltf/core
build /home/jpeters/Projekte/misa2/misa/pi-sdk
build /home/jpeters/Projekte/misa2/misa/misa-sdk
build /home/jpeters/Projekte/misa2/misa/serviceregistry-client

build /home/jpeters/Projekte/misa2/misa/relations
build /home/jpeters/Projekte/misa2/misa/servicegateway

#build7 /home/Projekte/misa2/pltf/search-api
#build7 /home/Projekte/misa2/pltf/login-api
#build7 /home/Projekte/misa2/pltf/serverbase

#build7 /home/Projekte/misa2/pltf/epm-ejb
#build7 /home/Projekte/misa2/pltf/dto-adapter
#build7 /home/Projekte/misa2/pltf/progresstracker
#build7 /home/Projekte/misa2/pltf/planningobject-ejb
build7 /home/Projekte/misa2/activity/activity

##############
#   CLIENT   #
##############
#build7 /home/Projekte/misa2/pltf-flex/framework
#build7 /home/Projekte/misa2/pltf-flex/core

##############
#   RM       #
##############
build /home/jpeters/Projekte/misa2/rm/rm
#build /home/jpeters/Projekte/misa2/rm/rm-flex

##############
#   DLM      #
##############
build /home/jpeters/Projekte/misa2/dlm/dlm
#build /home/jpeters/Projekte/misa2/dlm/dlm-flex

##############
#  EN4M      #
##############
build7 /home/jpeters/Projekte/misa2/pltf-flex/web-src
build7 /home/jpeters/Projekte/misa2/pltf/bundle
build7 /home/jpeters/Projekte/misa2/std/build
