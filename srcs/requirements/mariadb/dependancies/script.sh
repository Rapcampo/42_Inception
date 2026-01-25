#!/usr/bin/env bash

set -e

DATADIR=/var/lib/mysql
SOCKET=/run/mysql/mysqld.sock
DB_ROOT_PASSWORD="$(< /run/secrets/db_root_pass)"
WP_DB_PASSWORD="$(< /run/secrets/db_pass)"

:"${WP_BD_NAME:?WP_DB_NAME not set}"
:"${WP_BD_PASSWORD:?WP_DB_NAME not set}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
	echo "Starting MariaDB"

	mariadb-install-db --user=mysql --datadir="$DATADIR"
	chown -R mysql:mysql "$DATADIR"

	gosu mysql mariadbd \
		--datadir="$DATADIR" \
		--skip-networking --socket="$SOCKET" & pid="$!"

	until mysqladmin --protocol=socket --socket="$SOCKET" ping --silent; do
		sleep 1
	done

	mariadb --protocol=socket --socket="$SOCKET" -u root <<EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
	CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\`;
	CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${WP_DB_NAME}\`.* TO '${WP_DB_USER}'@'%';
	FLUSH PRIVILEGES;
EOSQL

	mysqladmin --protocol=socket --socket="$SOCKET" -u root -p"${DB_ROOT_PASSWORD}" shutdown
	wait "$pid"
fi

exec gosu mysql mariadbd \
	--datadir=/var/lib/mysql --bind-address=0.0.0.0
