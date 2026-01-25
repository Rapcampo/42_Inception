#!/usr/bin/env bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Starting MariaDB"

	DB_ROOT_PASSWORD="$(< /run/secrets/db_root_pass)" \
	WP_DB_PASSWORD="$(< /run/secrets/db_pass)"

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql

	gosu mysql mariadbd \
		--datadir=/var/lib/mysql \
		--skip-networking --socket=/run/mysqld/mysql.sock & pid="$!"

	until mysqladmin ping --socket=/run/mysqld/mysql.sock --silent; do
		sleep 1
	done

	mariadb -uroot -p"$DB_ROOT_PASSWORD" -e "
	CREATE DATABASE IF NOT EXISTS \`$WP_DB_NAME\`;
	CREATE USER IF NOT EXISTS '\`'$WP_DB_USER'\`'@'\`'%'\`' IDENTIFIED BY '\`'$WP_DB_PASSWORD'\`';
	GRANT ALL PRIVILEGES ON '\`'$WP_DB_NAME'\`'.* TO '\`'$WP_DB_USER'\`'@'\`'%'\`';
	FLUSH PRIVILEGES;
	"

	mysqladmin shutdown
	#kill "$pid"
fi

exec gosu mysql mariadbd \
	--datadir=/var/lib/mysql --bind-address=0.0.0.0
