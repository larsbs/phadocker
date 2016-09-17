# Set environment
. ./.env


echo "[INFO]: Removing containers..."
docker rm -f `docker ps -a -q -f "name=${CONTAINER_PREFIX}"`
echo "[INFO]: Removing containers... DONE\n"


if ([ "$1" ] && [ "$1" = "-i" ]) || ([ "$2" ] && [ "$2" = "-i" ]); then
    echo "[INFO]: Removing images..."
    docker rmi -f `docker images -f "dangling=true" -q`
    docker rmi -f `docker images -q -f "label=${CONTAINER_PREFIX}"`
    echo "[INFO]: Removing images... DONE\n"
fi


if ([ "$1" ] && [ "$1" = "-d" ]) || ([ "$2" ] && [ "$2" = "-d" ]); then
    echo "[INFO]: Deleting files..."
    rm -rf "${PHABRICATOR_LOCAL_REPODIR}"
    rm -rf "${PHABRICATOR_LOCAL_LOCALDISK_PATH}"
    rm -rf "${DB_LOCAL_DATADIR}"
    echo "[INFO]: Deleting files... DONE\n"
fi
