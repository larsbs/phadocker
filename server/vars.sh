# Configurable phabricator variables
# ==================================
#
# DB_HOST
# DB_PORT
# DB_USER
# DB_PASS
# BASE_URI
#
####################################


# Set defaults
if [ -z "${DB_HOST}" ]; then
    echo "WARNING: Using default value for DB_HOST"
    DB_HOST="localhost"
fi

if [ -z "${DB_PORT}" ]; then
    echo "WARNING: Using default value for DB_PORT"
    DB_PORT=3306
fi

if [ -z "${DB_USER}" ]; then
    echo "WARNING: Using default value for DB_USER"
    DB_USER="root"
fi

if [ -z "${DB_PASS}" ]; then
    echo "WARNING: Using default value for DB_PASS"
    DB_PASS="root"
fi

if [ -z "${BASE_URI}" ]; then
    echo "ERROR: No BASE_URI set"
    exit 1
fi
