#!/bin/bash

KEYCLOAK_HOME=/opt/jboss/keycloak
JBOSS_CLI=$KEYCLOAK_HOME/bin/jboss-cli.sh

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

function wait_for_exampleds_connection() {
  until `$JBOSS_CLI -c "/subsystem=datasources/data-source=ExampleDS:test-connection-in-pool" 2> /dev/null | grep -q [true]`; do
    sleep 1
  done
}

function wait_for_keycloakds_connection() {
  until `$JBOSS_CLI -c "/subsystem=datasources/data-source=KeycloakDS:test-connection-in-pool" 2> /dev/null | grep -q [true]`; do
    sleep 1
  done
}

echo $(date -u) "=> Removing data source KeycloakDS, if any, from the Keycloak server configuration"
$JBOSS_CLI -c "data-source remove --name=KeycloakDS" > /dev/null 2>&1
echo $(date -u) "=> Removing data source ExampleDS, if any, from the Keycloak server configuration"
$JBOSS_CLI -c "data-source remove --name=ExampleDS" > /dev/null 2>&1
$JBOSS_CLI -c ":reload" > /dev/null 2>&1

echo $(date -u) "=> Waiting for the Keycloak server to reload"
wait_for_server
echo $(date -u) "=> The Keycloak server has started successfully"

$JBOSS_CLI -c << EOF
/subsystem=datasources/jdbc-driver=h2:remove
module add --name=com.oracle --resources=/opt/jboss/keycloak/customization/ojdbc6.jar --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=com.oracle:add(driver-name=com.oracle, driver-module-name=com.oracle, driver-xa-datasource-class-name=oracle.jdbc.xa.client.OracleXADataSource)
data-source add --name=ExampleDS --driver-name=com.oracle --jndi-name=java:jboss/datasources/ExampleDS --connection-url=jdbc:oracle:thin:@db:1521:XE --user-name=nicolas --password=California1 --max-pool-size=25 --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.vendor.OracleValidConnectionChecker, --stale-connection-checker-class-name=org.jboss.jca.adapters.jdbc.vendor.OracleStaleConnectionChecker, --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleExceptionSorter
data-source  enable --name=ExampleDS
data-source add --name=KeycloakDS --driver-name=com.oracle --jndi-name=java:jboss/datasources/KeycloakDS --connection-url=jdbc:oracle:thin:@db:1521:XE --user-name=nicolas --password=California1 --max-pool-size=25 --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.vendor.OracleValidConnectionChecker, --stale-connection-checker-class-name=org.jboss.jca.adapters.jdbc.vendor.OracleStaleConnectionChecker, --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleExceptionSorter
data-source  enable --name=KeycloakDS
:reload
EOF
echo $(date -u) "=> Oracle data-source and driver correctly configured for the Keycloak server. Waiting for the Wildfly server to reload"
wait_for_server
echo $(date -u) "=> The Keycloak server started successfully"
echo $(date -u) "=> Testing the new ExampleDS datasource for the Keycloak server"
wait_for_exampleds_connection
echo $(date -u) "=> The test of the Oracle ExampleDS datasource for the Keycloak server has succeeded"
echo $(date -u) "=> Testing the new KeycloakDS datasource for the Keycloak server"
wait_for_keycloakds_connection
echo $(date -u) "=> The test of the Oracle KeyCloakDS datasource for the Keycloak server has succeeded"

