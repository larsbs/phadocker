# Configurable variables
# ======================
#
# DB_DATADIR
# DB_ROOT_PASS
# DB_USER
# DB_PASS
# DB_NAME
#
########################


# Set needed defaults
if [ -z "${DB_DATADIR}" ]; then
    echo "WARNING: Using default value for DB_DATADIR"
    DB_DATADIR="/var/lib/mysql"
fi

if [ -z "${DB_ROOT_PASS}" ]; then
    echo "WARNING: Using default value for DB_ROOT_PASS"
    DB_ROOT_PASS="root"
fi

if [ -z "${DB_PASS}" ]; then
    echo "WARNING: Using default value for DB_PASS"
    DB_PASS="${DB_ROOT_PASS}"
fi
