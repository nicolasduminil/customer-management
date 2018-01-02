#!/bin/bash
WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh
$WILDFLY_HOME/bin/add-user.sh admin admin
if [ ! -f  ./keycloak-wildfly-adapter-dist-3.4.2.Final.tar.gz ]
then
  curl -O -s https://downloads.jboss.org/keycloak/3.4.2.Final/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-3.4.2.Final.tar.gz 
fi
tar xzf keycloak-wildfly-adapter-dist-3.4.2.Final.tar.gz -C $WILDFLY_HOME
$JBOSS_CLI --file=$WILDFLY_HOME/bin/adapter-install-offline.cli
