#!/bin/sh
WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh

function wait_for_server() {
  until $($JBOSS_CLI -c ":read-attribute(name=server-state)" | grep -q running); do
    sleep 1
  done
}

wait_for_server
echo $(date -u) "=> Deploying customer-management.ear"
$JBOSS_CLI -c "deploy ./wildfly/customization/target/customer-management.ear"
echo $(date -u) "=> customer-management.ear successfully deployed"
