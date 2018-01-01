#!/bin/sh
WILDFLY_HOME=/opt/jboss/wildfly
JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh

echo $(date -u) "=> Downloading the Keycloak Adapter for Wildfly"
if [ ! -f  ./keycloak-wildfly-adapter-dist-3.4.2.Final.tar.gz ]
then
  echo $(date -u) "=> Keycloak Adapter for Wildfly not yet downloaded. Dowloading it."
  curl -O -s https://downloads.jboss.org/keycloak/3.4.2.Final/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-3.4.2.Final.tar.gz 
else
  echo $(date -u) "=> Keycloak Adapter for Wildfly already downloaded." 
fi
echo $(date -u) "=> Unpacking Keycloak Adapter for Wildfly."
tar xzf keycloak-wildfly-adapter-dist-3.4.2.Final.tar.gz -C $WILDFLY_HOME

echo $(date -u) "=> Installing Keycloak Adapter for Wildfly."
$JBOSS_CLI --file=$WILDFLY_HOME/bin/adapter-install-offline.cli
echo $(date -u) "=> Keycloak Adapter for Wildfly installed successfully. Reloading ..."
