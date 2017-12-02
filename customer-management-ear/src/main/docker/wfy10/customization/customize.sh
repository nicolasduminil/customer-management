#!/bin/bash

WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

function wait_for_jdbc_connection() {
  until `$JBOSS_CLI -c "/subsystem=datasources/data-source=ExampleDS:test-connection-in-pool" 2> /dev/null | grep -q [true]`; do
    sleep 1
  done
}

echo $(date -u) "=> Replacing H2 JDBC drivers and ExampleDS datasource by the Oracle XE ones"
$JBOSS_CLI --file=$WILDFLY_HOME/customization/customize.cli > /dev/null

echo $(date -u) "=> Oracle JDBC drivers and ExampleDS datasource customization terminated. Waiting for the Wildfly server to reload"
$JBOSS_CLI -c ":reload" > /dev/null
wait_for_server
echo $(date -u) "=> The Wildfly server started successfully"
echo $(date -u) "=> Testing the new Wildfly ExampleDS datasource"
wait_for_jdbc_connection
echo $(date -u) "=> The Wildfly ExampleDS datasource for Oracle test has succeeded"

$WILDFLY_HOME/bin/add-user.sh nicolas California1$

echo $(date -u) "=> Deploying customer-management.ear"
$JBOSS_CLI -c "deploy ./wildfly/customization/target/customer-management.ear"
echo $(date -u) "=> customer-management.ear successfully deployed"

echo $(date -u) "=> Downloading the Keycloak Adapter for Wildfly"
if [ ! -f  ./keycloak-wildfly-adapter-dist-3.4.0.Final.tar.gz ]
then
  echo $(date -u) "=> Keycloak Adapter for Wildfly not yet downloaded. Dowloading it."
  curl -O -s https://downloads.jboss.org/keycloak/3.4.0.Final/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-3.4.0.Final.tar.gz  
else
  echo $(date -u) "=> Keycloak Adapter for Wildfly already downloaded."
fi
echo $(date -u) "=> Unpacking Keycloak Adapter for Wildfly."
tar xzf keycloak-wildfly-adapter-dist-3.4.0.Final.tar.gz -C $WILDFLY_HOME

echo $(date -u) "=> Installing Keycloak Adapter for Wildfly."
$JBOSS_CLI --file=$WILDFLY_HOME/bin/adapter-install-offline.cli > /dev/null
echo $(date -u) "=> Keycloak Adapter for Wildfly installed successfully."

