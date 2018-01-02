#!/bin/sh
WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh
function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}
wait_for_server
$JBOSS_CLI -c "deploy ./wildfly/customization/target/customer-management.ear"