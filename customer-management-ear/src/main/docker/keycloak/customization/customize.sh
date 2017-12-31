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
$KCADM create realms -s realm=demo-realm -s enabled=true 
echo $(date -u) "=> Successfuly created demo-realm"
$KCADM create users -r demo-realm -s username=customer-manager-user -s enabled=true
$KCADM set-password -r demo-realm --username customer-manager-user --new-password California1
echo $(date -u) "=> Successfuly created customer-manager-user"
$KCADM create clients -r demo-realm -s clientId=customer-manager-client -s bearerOnly="true" -s "redirectUris=[\"http://localhost:8080/customer-management/*\"]" -s enabled=true
echo $(date -u) "=> Successfuly created customer-manager-client"
$KCADM create clients -r demo-realm -s clientId=curl -s publicClient="true" -s directAccessGrantsEnabled="true" -s "redirectUris=[\"http://localhost\"]" -s enabled=true
echo $(date -u) "=> Successfuly created curl client"
$KCADM create roles -r demo-realm -s name=customer-manager-role
echo $(date -u) "=> Successfuly created the customer-manager-role"
$KCADM add-roles --uusername customer-manager-user --rolename customer-manager-role -r demo-realm
echo $(date -u) "=> Successfuly added role customer-manager-role to the customer-manager-user"

