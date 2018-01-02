#!/bin/bash
WILDFLY_HOME=/opt/jboss/keycloak
KCADM=$WILDFLY_HOME/bin/kcadm.sh
$KCADM config credentials --server http://localhost:8080/auth --realm master --user admin --password admin
$KCADM create users -r master -s username=customer-admin -s enabled=true
$KCADM set-password -r master --username customer-admin --new-password admin
$KCADM create clients -r master -s clientId=customer-manager-client -s bearerOnly="true" -s "redirectUris=[\"http://localhost:8080/customer-management/*\"]" -s enabled=true
$KCADM create clients -r master -s clientId=curl -s publicClient="true" -s directAccessGrantsEnabled="true" -s "redirectUris=[\"http://localhost\"]" -s enabled=true
$KCADM create roles -r master -s name=customer-manager
$KCADM add-roles --uusername customer-admin --rolename customer-manager -r master

