#!bin/bash

if [-f /etc/mysql/init.sql]; then
	export MYSQL_ROOT_PASSWORD="$(< /run/secrets/db_root_password)" && \
	export MYSQL_PASSWORD="$(< /run/secrets/db_password)" && \
	envsubst < /etc/mysql/init.sql > /tmp/init.sql
	chown mysql:mysql /tmp/init.sql
	chmod 660 /tmp/init.sql

else
	echo "Error: could not find init.sql file in /etc/mysql"
	exit 1
fi

exec mariadb
