#!/bin/bash

set -e


# Set environment
. ./.env


build_db_image() {
    docker build -t "sindrosoft/${CONTAINER_PREFIX}_${CONTAINER_DB_NAME}" database/
}


build_phabricator_image() {
    docker build -t "sindrosoft/${CONTAINER_PREFIX}_${CONTAINER_PHABRICATOR_NAME}" server/
}


run_db_container() {
    docker run -i -t -d \
        --name ${CONTAINER_PREFIX}_${CONTAINER_DB_NAME} \
        -e "DB_USER=${DB_USER}" \
        -e "DB_PASS=${DB_PASS}" \
        -e "DB_ROOT_PASS=${DB_PASS}" \
        -e "DB_DATADIR=${DB_DATADIR}" \
        -v "${DB_LOCAL_DATADIR}":"${DB_DATADIR}" \
        "sindrosoft/${CONTAINER_PREFIX}_${CONTAINER_DB_NAME}"
}


run_phabricator_container() {
    docker run -i -t -d \
        -p ${EXTERNAL_HTTP_PORT}:80 \
        --name ${CONTAINER_PREFIX}_${CONTAINER_PHABRICATOR_NAME} \
        --link "${CONTAINER_PREFIX}_${CONTAINER_DB_NAME}:${DB_HOST}" \
        -e "DB_HOST=${DB_HOST}" \
        -e "DB_PORT=${DB_PORT}" \
        -e "DB_USER=${DB_USER}" \
        -e "DB_PASS=${DB_PASS}" \
        -e "BASE_URI=${BASE_URI}" \
        -e "PHABRICATOR_LOCALDISK_PATH=${PHABRICATOR_LOCALDISK_PATH}" \
        -e "MAIGUN_DOMAIN=${MAILGUN_DOMAIN}" \
        -e "MAILGUN_API_KEY=${MAILGUN_API_KEY}" \
        -v "${PHABRICATOR_LOCAL_REPODIR}":"${PHABRICATOR_REPODIR}" \
        -v "${PHABRICATOR_LOCAL_LOCALDISK_PATH}":"${PHABRICATOR_LOCALDISK_PATH}" \
        "sindrosoft/${CONTAINER_PREFIX}_${CONTAINER_PHABRICATOR_NAME}"
}


build_db_image
build_phabricator_image
run_db_container
run_phabricator_container

# Log output when running phabricator
docker logs -f ${CONTAINER_PREFIX}_${CONTAINER_PHABRICATOR_NAME}
