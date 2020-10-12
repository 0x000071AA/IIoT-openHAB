#!/bin/bash -x
set -eo pipefail

NEW_USER_ID=${USER_ID:-9001}
NEW_GROUP_ID=${GROUP_ID:-$NEW_USER_ID}

adduser -u $NEW_USER_ID --disabled-password --gecos '' --home "${OPENHAB_HOME}" --gid $NEW_GROUP_ID openhab

chown -R openhab:openhab "${OPENHAB_HOME}"

# Deleting instance.properties to avoid karaf PID conflict on restart
# See: https://github.com/openhab/openhab-docker/issues/99
rm -f "${OPENHAB_HOME}/runtime/instances/instance.properties"

# The instance.properties file in openHAB 2.x/3.x is installed in the tmp
# directory
rm -f "${OPENHAB_USERDATA}/tmp/instances/instance.properties"

sync

# Run s6-style init continuation scripts if existent
if [ -d /etc/cont-init.d ]
then
    for script in $(find /etc/cont-init.d -type f | grep -v \~ | sort)
    do
        . "${script}"
    done
fi

# sync again after continuation scripts have been run
sync

exec "$@"