echo Restarting boot2docker...
docker-machine restart opendsa

sleep 1
echo Exporting Docker variables...
eval $(docker-machine env opendsa)


sleep 1
echo Removing orphaned images without tags...
docker image prune