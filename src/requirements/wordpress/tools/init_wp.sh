#!/bin/bash

# Check if WordPress has already been downloaded
WP_PATH="/var/www/html/$DOMAIN_NAME/public_html"

if ! [ -d "$WP_PATH" ]; then
	echo "Inception : ✔ Download core WordPress files to $WP_PATH"
	mkdir -p "$WP_PATH"
	chown -R www-data:www-data /var/www/html/$DOMAIN_NAME/public_html
	chmod -R 755 /var/www/html/$DOMAIN_NAME/public_html
	wp core download --path="$WP_PATH" --allow-root
fi

# Create the directory for PHP-FPM PID file if it does not exist
mkdir -p /run/php
chown -R www-data:www-data /run/php
chmod -R 755 /run/php

echo $PATH

if ! /usr/sbin/php-fpm7.4 --version; then
	echo "Error: php-fpm not found!"
    exit 1
fi

# Set correct ownership for the WordPress directory
echo "Inception : ✔ Set correct ownership for the WordPress directory"

cd $WP_PATH

# If wp-config.php does not exist, create a new configuration
if [ ! -f wp-config.php ]; then
	echo "Creating wp-config.php"

	wp config create \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_USER_PW \
		--dbhost=$DB_HOST \
		--path=$WP_PATH \
		--allow-root

	echo "wp-config.php created"

	echo "[WORDPRESS] Database Check"
	until wp db check --allow-root; do
		echo "[WORDPRESS] Waiting for MariaDB to be ready..."
		sleep 5
	done

	# Install WordPress
	wp core install --url=$DOMAIN_NAME \
					--title='42 INCEPTION' \
					--admin_user=$WP_ADMIN_USER \
					--admin_password=$WP_ADMIN_PW \
					--admin_email=$WP_ADMIN_MAIL \
					--allow-root

	# Create the user
	wp user create $WP_USER $WP_USER_MAIL \
					--user_pass=$WP_USER_PW \
					--allow-root
fi

# Start PHP-FPM in the background
echo "Start PHP-FPM"
exec php-fpm7.4 -F
