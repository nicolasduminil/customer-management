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
