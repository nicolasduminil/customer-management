#!/bin/bash

WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
$WILDFLY_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 &

echo "=> Waiting for the server to boot"
wait_for_server

$JBOSS_CLI -c << EOF
batch

# Remove the datasources and the H2 driver 
data-source remove --name=ExampleDS
/subsystem=datasources/jdbc-driver=h2:remove

# Add Oracle module
module add --name=com.oracle.db --resources=/opt/jboss/wildfly/customization/ojdbc6.jar --dependencies=javax.api, javax.api,javax.transaction.api

# Add Oracle JDBC driver
/subsystem=datasources/jdbc-driver=oracle:add( 
    driver-name=oracle, 
    driver-module-name=oracle.jdbc, 
    driver-xa-datasource-class-name=oracle.jdbc.xa.client.OracleXADataSource 
)

# Add a non-XA datasource
data-source add 
    --name=ExampleDS 
    --driver-name=oracle 
    --jndi-name=java:jboss/datasources/ExampleDS 
    --connection-url=jdbc:oracle:thin:@localhost:1521:XE
    --user-name=nicolas 
    --password=California1 
    --max-pool-size=25
    --valid-connection-checker class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker"
    --stale-connection-checker class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker"
    --exception-sorter class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionSorter"
data-source  enable --name=ExampleDS

# Add an XA datasource
xa-data-source add 
    --name=ExampleXADS 
    --driver-name=oracle 
    --jndi-name=java:jboss/datasources/ExampleXADS 
    --user-name=nicolas
    --password=California1 
    --recovery-username=nicolas
    --recovery-password=California1 
    --use-ccm=false 
    --max-pool-size=25 
    --blocking-timeout-wait-millis=5000 
    --new-connection-sql="set datestyle = ISO, European;"
/subsystem=datasources/xa-data-source=ExampleXADS/xa-datasource-properties=ServerName:add(value=localhost)
/subsystem=datasources/xa-data-source=ExampleXADS/xa-datasource-properties=PortNumber:add(value=1521)
/subsystem=datasources/xa-data-source=ExampleXADS/xa-datasource-properties=DatabaseName:add(value=XE)
xa-data-source enable --name=ExampleXADS

# Execute the batch
run-batch

# Reload config
/:reload
EOF

# Create user
$WILDFLY_HOME/bin/add-user.sh nicolas California1$
