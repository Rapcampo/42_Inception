#!/usr/bin/env bash

set -e

if [ ! -d "/var/lib/mysql/mysql"]; then
	echo "Starting MariaDB"

	export DB_ROOT_PASSWORD="$(< /run/secrets/db_root_password)" \
		&& export WP_DB_PASSWORD="$(< /run/secrets/db_password)"

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql

	gosu mysql mariadb \
		--datadir=/var/lib/mysql \
		-- skip-networking --socket=/tmp/mysql.sock & pid="$!"

	until mysqladmin ping --socket/tmp/mysql.sock --silent; do
		sleep 1
	done

	mysql -u root --socket=/tmp/mysql.sock <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOTP_PASSWORD';
	CREATE DATABASE IF NOT EXISTS \'$WP_DB_NAME\';
	CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
	GRANT ALL PRIVILEGES ON \'$WP_DB_NAME'.* TO '$WP_DB_USER'@'%';
	FLUSH PRIVILEGES
	EOSQL

	kill "$pid"
fi

exec gosu mysql mariadbd \
	--datadir=/var/lib/mysql --bind-address=0.0.0.0
