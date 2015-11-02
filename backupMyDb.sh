#!/bin/bash

TS=`date +%Y%m%d-%H%M%S`
BAK_DIR_ROOT=/opt/backup/mysql/databases
USER=root
PASS=B1gS3cr37

MYSQLDUMP_BIN="/usr/bin/mysqldump"
MYSQLDUMP_OPTS="--add-drop-database --add-drop-table --master-data --flush-logs --delayed-insert --flush-privileges --disable-keys --routines --dump-date --single-transaction"
MYSQLDUMP="${MYSQLDUMP_BIN} ${MYSQLDUMP_OPTS}"

MYSQL_BIN="/usr/bin/mysql"
MYSQL_OPTS=
MYSQL="${MYSQL_BIN} ${MYSQL_OPTS}"

usage() {
	cat <<_EOU

Usage: $(basename $0) db1 [db2 [db3...]]

_EOU
}

# Check the command line parameters
if [ -z "$*" ]
then
	usage
	exit 1
fi

err=0
for db in "$@"
do
	BAK_DIR="${BAK_DIR_ROOT}/${db}"

	# Make sure directory exists
	[ -d ${BAK_DIR} ] || mkdir -p ${BAK_DIR};

	# Do the backup
	${MYSQLDUMP} -u ${USER} -p${PASS} ${db} | gzip -c9 > ${BAK_DIR}/${db}-${TS}.sql.gz;
	if [ $? -ne 0 ]
	then
		err=$((err + 1))
	fi
done

exit ${err}
