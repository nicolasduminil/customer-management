docker exec -ti keycloak keycloak/customization/customize.sh
docker exec -ti wfy10 wildfly/customization/customize.sh
docker restart wfy10
docker exec -ti wfy10 wildfly/customization/deploy.sh
