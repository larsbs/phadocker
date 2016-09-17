#!/bin/bash

set -e


# Default vars
. ./vars.sh


setup_phabricator_and_start_apache() {
    # Wait for database to be ready
    timeout=30
    echo -n "Waiting for database to be ready"
    while ! mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} -e ";" > /dev/null 2>&1 ; do
        timeout=$((${timeout} - 1))
        if [ ${timeout} -eq 0 ]; then
            echo -e "\nTIMEOUT: Could not connect to database. Aborting..."
            exit 1
        fi
        echo -n "."
        sleep 1
    done
    echo

    # Set /var/disk as writable by the server
    chown -R www-data:www-data /var/disk

    # Setup phabricator database connection
    ./phabricator/bin/config set mysql.host ${DB_HOST}
    ./phabricator/bin/config set mysql.port ${DB_PORT}
    ./phabricator/bin/config set mysql.user ${DB_USER}
    ./phabricator/bin/config set mysql.pass ${DB_PASS}

    # Setup MySQL schema
    ./phabricator/bin/storage upgrade --force

    # Setup phabricator base URI
    ./phabricator/bin/config set phabricator.base-uri "${BASE_URI}"

    # Start phabricator daemons
    ./phabricator/bin/phd start

    # Enable pygments
    ./phabricator/bin/config set pygments.enabled true

    # Configure file storage on local disk
    ./phabricator/bin/config set storage.local-disk.path "${PHABRICATOR_LOCALDISK_PATH}"

    # If MAILGUN vars are set, setup mailgun as mail client
    if [ ! -z "${MAILGUN_DOMAIN}" ] && [ ! -z "${MAILGUN_API_KEY}" ]; then
        ./phabricator/bin/config set metamta.mail-adapter PhabricatorMailImplementationMailgunAdapter
        ./phabricator/bin/config set mailgun.domain ${MAILGUN_DOMAIN}
        ./phabricator/bin/config set mailgun.api-key ${MAILGUN_API_KEY}
    fi

    # Start apache
    service apache2 start && tail -f /var/log/apache2/access.log
}


if [ "${1}" = "start" ]; then
    setup_phabricator_and_start_apache
else
    exec "$@"
fi
