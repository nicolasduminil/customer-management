#!/bin/bash

WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
$WILDFLY_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 > /dev/null 2>&1 &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Removing data source ExampleDS, if any"
$JBOSS_CLI -c --commands="data-source remove --name=ExampleDS" > /dev/null 2>&1
$JBOSS_CLI -c --commands=":reload" > /dev/null 2>&1

echo "=> Waiting for the server to reload"
wait_for_server

$JBOSS_CLI -c << EOF > /dev/null 2>&1
/subsystem=datasources/jdbc-driver=h2:remove
module add --name=com.oracle --resources=/opt/jboss/wildfly/customization/ojdbc6.jar --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=com.oracle:add(driver-name=com.oracle, driver-module-name=com.oracle, driver-xa-datasource-class-name=oracle.jdbc.xa.client.OracleXADataSource)
data-source add --name=ExampleDS --driver-name=com.oracle --jndi-name=java:jboss/datasources/ExampleDS --connection-url=jdbc:oracle:thin:@db:1521:XE --user-name=nicolas --password=California1 --max-pool-size=25 --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker, --stale-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker, --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionSorter
data-source  enable --name=ExampleDS
/subsystem=infinispan/cache-container=oauth20:add(jndi-name="infinispan/oauth20-container", default-cache="clientid")
/subsystem=infinispan/cache-container=oauth20/local-cache=clientid:add()
/subsystem=infinispan/cache-container=oauth20/local-cache=clientid/component=transaction:write-attribute(name=mode, value="NONE")
/subsystem=infinispan/cache-container=oauth20/local-cache=clientid/component=eviction:write-attribute(name=strategy, value="NONE")
:reload
EOF

echo "=> Infinispan cache and Oracle data-source and driver correctly configured. Waiting for the server to reload"
wait_for_server
$WILDFLY_HOME/bin/add-user.sh nicolas California1$

echo "=> Deploying customer-management.war"
$JBOSS_CLI -c --commands="deploy ./wildfly/target/customer-management.war" > /dev/null 2>&1

