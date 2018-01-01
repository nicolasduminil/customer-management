#!/bin/bash

WILDFLY_HOME=/opt/jboss/keycloak
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh
KCADM=$WILDFLY_HOME/bin/kcadm.sh
KCREG=$WILDFLY_HOME/bin/kcreg.sh

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

echo $(date -u) "=> Customizing the Keycloak server"
#$JBOSS_CLI --file=keycloak/customization/customize.cli
echo $(date -u) "=> Successfuly executed customize.cli"
$KCADM config credentials --server http://localhost:8080/auth --realm master --user nicolas --password California1
$KCADM create users -r master -s username=customer-admin -s enabled=true
$KCADM set-password -r master --username customer-admin --new-password California1
echo $(date -u) "=> Successfuly created customer-admin"
$KCADM create clients -r master -s clientId=customer-manager-client -s bearerOnly="true" -s "redirectUris=[\"http://localhost:8080/customer-management/*\"]" -s enabled=true
echo $(date -u) "=> Successfuly created customer-manager-client"
$KCADM create clients -r master -s clientId=curl -s publicClient="true" -s directAccessGrantsEnabled="true" -s "redirectUris=[\"http://localhost\"]" -s enabled=true
echo $(date -u) "=> Successfuly created curl client"
$KCADM create roles -r master -s name=customer-manager
echo $(date -u) "=> Successfuly created the customer-manager role"
$KCADM add-roles --uusername customer-admin --rolename customer-manager -r master
echo $(date -u) "=> Successfuly added role customer-manage to the customer-admin"

