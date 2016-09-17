#!/bin/bash


# Set environment
. ./.env


start_db_container() {
    docker start $(docker ps -a -q -f "name=${CONTAINER_PREFIX}_${CONTAINER_DB_NAME}")
}


start_server_container() {
    docker start $(docker ps -a -q -f "name=${CONTAINER_PREFIX}_${CONTAINER_PHABRICATOR_NAME}")
}


start_db_container
start_server_container
