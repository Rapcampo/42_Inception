<?php
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') );
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') );
define( 'DB_PASSWORD', trim( file_get_contents( getenv('WORDPRESS_DB_PASSOWRD_FILE') ) ) );

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', true );

define( 'WP_HOME', 'https://' . getenv('DOMAIN_NAME') );
define( 'WP_SITEURL', 'https://' . getenv('DOMAIN_NAME') );

$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . "wp-settings.php";
