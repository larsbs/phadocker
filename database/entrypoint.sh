#!/bin/bash


# Get variables
. ./vars.sh


prepare_and_start_mysql() {
    # Initialize mysql
    echo "Initializing mysql server..."
    mysql_install_db --user=mysql --datadir="${DB_DATADIR}" --keep-my-cnf > /dev/null 2>&1

    # Start mysql server
    mysqld_safe > /dev/null 2>&1 &

    # Wait for mysql server to start(max 30 seconds)
    timeout=30;
    echo -n 'Waiting for database server to accept connections'
    while [ ! -x /var/run/mysqld/mysqld.sock ]; do
        timeout=$((${timeout} - 1))
        if [ ${timeout} -eq 0 ]; then
            echo -e "\nCould not connect to database server. Aborting..."
            exit 1
        fi
        echo -n '.'
        sleep 1
    done

    # Delete default anonymous users, create root user and delete test tables
    echo -e "\nSecuring mysql installation..."
    mysql -uroot <<-EOSQL
        SET @@SESSION.SQL_LOG_BIN=0;

        DELETE FROM mysql.user;
        CREATE USER 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';
        GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
        DROP DATABASE IF EXISTS test;
        FLUSH PRIVILEGES;
EOSQL

    # Create user and database if vars are set
    if [ ! -z "${DB_USER}" ] && [ ! -z "${DB_NAME}" ] && [ ! -z "${DB_PASS}" ]; then
        echo -e "\nCreating database ${DB_NAME} and user ${DB_USER}..."
        mysql -uroot -p"${DB_ROOT_PASS}" <<-EOSQL
            CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
            DROP DATABASE IF EXISTS ${DB_NAME}; CREATE DATABASE ${DB_NAME};
            GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;
            FLUSH PRIVILEGES;
EOSQL
    fi

    # Stop mysql server to restart it later with all changes
    mysqladmin -uroot -p"${DB_ROOT_PASS}" shutdown

    # Start mysql again
    echo -e "\nStarting mysql server...\n"
    mysqld_safe
}


if [ "${1}" = 'mysqld_safe' ]; then
    prepare_and_start_mysql
else
    exec "$@"
fi
