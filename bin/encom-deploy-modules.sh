#!/bin/bash
cd /home/jpeters/Projekte/misa2/
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot relations-ws ./misa/relations/relations-ws/target/relations-ws.war
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot rm-ws ./rm/rm/rm-ws/target/rm-ws-2.1.1-SNAPSHOT.war
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot dlm-ws ./dlm/dlm/target/dlm-ws-1.0.0-SNAPSHOT.war
~/GlassFish_Payara41/bin/asadmin deploy --force --contextroot servicegateway-ws ./misa/servicegateway/servicegateway-ws/target/servicegateway-ws-2.0.0-SNAPSHOT.war
