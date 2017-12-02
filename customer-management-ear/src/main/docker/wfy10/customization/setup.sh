function wait_for_db() {
  until [ $(docker inspect -f {{.State.Health.Status}} oraxe) == "healthy" ]
  do
    sleep 1;
   done
}

echo $(date -u) "=> Waiting for the Oracle XE database to start. This might last for a while, please be patient."
wait_for_db
echo $(date -u) "=> The Oracle XE database has started"
docker exec -ti wfy10 wildfly/customization/customize.sh
echo $(date -u) "=> Running the Wildfly embedded server to configure Keycloak datasources and Oracle JDBC drivers"
docker exec -ti keycloak keycloak/bin/jboss-cli.sh --file=keycloak/customization/customize.cli
echo $(date -u) "=> The Keycloak datasources and Oracle JDBC drivers have been configured successfully"

