#!/usr/bin/env bash

set -e

DATADIR=/run/mysql
SOCKET=/run/mysql/mysqld.sock
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_pass)"
WP_DB_PASSWORD="$(cat /run/secrets/db_pass)"

if [ ! -d "$DATADIR" ]; then
	echo "Starting MariaDB"

	mariadb-install-db --user=mysql --datadir="$DATADIR"
	chown -R mysql:mysql "$DATADIR"

	gosu mysql mariadbd \
		--datadir="$DATADIR" \
		--skip-networking --socket="$SOCKET" & pid="$!"

	until mysqladmin --protocol=socket --socket="$SOCKET" ping --silent; do
		sleep 1
	done

	mariadb --protocol=socket --socket="$SOCKET" -uroot -p"$DB_ROOT_PASSWORD" <<EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
	CREATE DATABASE IF NOT EXISTS \`$WP_DB_NAME\`;
	CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`$WP_DB_NAME\`.* TO '${WP_DB_USER}'@'%';
	FLUSH PRIVILEGES;
EOSQL

	mysqladmin --protocol=socket --socket="$SOCKET" -u root -p"$DB_ROOT_PASSWORD" shutdown
	wait "$pid"
fi

exec gosu mysql mariadbd \
	--datadir="$DATADIR" --bind-address=0.0.0.0
