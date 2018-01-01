function wait_for_db() {
  until [ $(docker inspect -f {{.State.Health.Status}} oraxe) == "healthy" ]
  do
    sleep 1;
   done
}

#echo $(date -u) "=> Waiting for the Oracle XE database to start. This might last for a while, please be patient."
#wait_for_db
#echo $(date -u) "=> The Oracle XE database has started"
docker exec -d wfy10 wildfly/customization/customize.sh
#echo $(date -u) "=> Running the Wildfly embedded server to configure Keycloak datasources and Oracle JDBC drivers"
docker exec -ti keycloak keycloak/customization/customize.sh > /dev/null
#echo $(date -u) "=> The Keycloak datasources and Oracle JDBC drivers have been configured successfully"
docker exec -ti wfy10 wildfly/customization/install-keycloak-adapter.sh > /dev/null
echo $(date -u) "=> The Keycloak adapter has been configured successfully. Reloading ..."
docker restart wfy10 > /dev/null
#docker exec -d wfy10 wildfly/customization/add-secure-deployment.sh
#echo $(date -u) "=> The secure-deployment element has been configured successfully."
docker exec -d wfy10 wildfly/customization/deploy.sh
echo $(date -u) "=> customer-management.ear has been deployed successfully."
