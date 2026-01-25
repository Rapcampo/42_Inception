#!/usr/bin/env bash

WP_ADMIN_PASS="$(cat /run/secrets/wp_admin_password)"
WP_USER_PASS="$(cat /run/secrets/wp_user_password)"
WP_URL="https://${DOMAIN_NAME}"
until wp db check --path=/var/www/html --allow-root; do
	echo "Waiting for database..."
	sleep 2
done

if ! wp core is-installed --path=/var/www/html --allow-root; then
	wp core install \
		--url="${WP_URL}" \
		--title="${COMPOSE_PROJECT_NAME}" \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASS" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--path=/var/www/html \
		--skip-email \
		--allow-root
	wp user create \
		"$WP_USER" "$WP_USER_EMAIL" \
		--role=editor \
		--user_pass="$WP_USER_PASS" \
		--path=/var/www/html \
		--allow-root
	wp option update siteurl "${WP_URL}" --path=/var/www/html --allow-root
	wp option update home "${WP_URL}" --path=/var/www/html --allow-root
fi

exec "php-fmp" "-F"
