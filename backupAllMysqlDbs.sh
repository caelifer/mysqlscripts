#!/bin/bash

USER=root
PASS=B1gS3cr37

BACKUP_SCRIPT="$HOME/bin/backupMyDb.sh"

MYSQL_BIN="/usr/bin/mysql"
MYSQL_OPTS=
MYSQL="${MYSQL_BIN} ${MYSQL_OPTS}"

usage() {
	cat <<_EOU

Usage: $(basename $0) [-h]

_EOU
}

# Check the command line parameters
if [ $# -gt 0 ]
then
	usage
	exit 1
fi

# Get all database names
DB_LIST=$(${MYSQL} -p${PASS} -u${USER} -e 'show databases' | sed 1d | grep -v information_schema)

# Back up database - one at the time
err=0
for db in ${DB_LIST}
do
	# Back up selected database
	printf "Database '${db}' backup - "
	${BACKUP_SCRIPT} ${db}
	if [ $? -eq 0 ]
	then
		echo "Success" 
	else
		err=$((err + 1))
		echo "Failed"
	fi
done

exit $err
