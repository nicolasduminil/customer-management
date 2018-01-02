docker exec -ti keycloak keycloak/customization/customize.sh > /dev/null
docker exec -ti wfy10 wildfly/customization/customize.sh > /dev/null
docker restart wfy10 > /dev/null
docker exec -ti wfy10 wildfly/customization/deploy.sh > /dev/null
