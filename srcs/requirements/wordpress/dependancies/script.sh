#!/usr/bin/env bash

set -e

WP_ADMIN_PASSWORD="$(</run/secrets/wp_admin_password.txt)"
WP_DB_PASSWORD="$(</run/secrets/db_password.txt)"
WP_USER_PASSWORD="$(</run/secrets/wp_user_password.txt)"

until mysqladmin ping -h"$WP_DB_HOST" -u"$WP_DB_USER" -p"$WP_USER_PASSWORD" --silent; do
	sleep 1
done

if [ ! -f wp-config.php ]; then
	echo "Downloading and Installing wordpress"

	wp core download --allow-root

	wp config create --allow-root \
		--dbname="$WP_DB_NAME" \
		--dbuser="$WP_DB_USER" \
		--dbpass="$WP_DB_PASSWORD" \
		--dbhost="$WP_DB_HOST" \
		--skip-check

	wp core install --allow-root \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL"

	wp user create --allow-root \
		"$WP_USER" "$WP_EMAIL" \
		--user_pass="$WP_USER_PASS"

	echo "Wordpress installation finished!"
else
	echo "Wordpress has already been installed"
fi

exec php-fpm83 -F
