#!/bin/bash

wp-bootstrap() {

	echo "Preparing WordPress"

	cd /wp-core

	echo "Making sure permissions are correct"

	# Make sure permissions are correct (maybe can be avoided with https://stackoverflow.com/a/56990338).
	chown -R www-data:www-data /wp-core
	chmod 755 /wp-core

	echo "Making sure the database is up and running"

	while ! mysqladmin ping -hmysql --silent; do

		echo 'Waiting for the database'
		sleep 1

	done

	echo 'The database is ready'

	# Make sure WordPress is installed.
	if ! $(wp core is-installed); then

		echo "Installing WordPress"

		wp core install --url=wordpress:8080 --title=tests --admin_user=admin --admin_password=password --admin_email=admin@plugins.skyverge.test

		# The development version of Gravity Flow requires SCRIPT_DEBUG
		wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=wordpress --extra-php="define( 'SCRIPT_DEBUG', true );" --force

	fi

	wp plugin install woocommerce --activate
	wp plugin install woocommerce-admin --activate

	# remove WooCommerce admin notices
	wp option update woocommerce_admin_notices [] --format=json

	# prevent WooCommerce redirection to Setup Wizard
	wp transient delete _wc_activation_redirect

	wp db export fresh-install.sql

	echo "Preparing plugin"

	cd /project

	# Install vendor
	composer install --prefer-dist --optimize-autoloader
 
	if [ -f codeception.sh ]; then
		source codeception.sh
	fi

	echo "WordPress is ready"
}

if [[ "$1" == bootstrap ]]; then

	wp-bootstrap

elif [[ "$1" == start ]]; then

	wp-bootstrap

	# keep the service running...
	tail -f /dev/null

# TODO: add an entry point that will execute the command as www-data using: sudo -E -u www-data "$@"

else

	# allow one-off command execution
	exec "$@"

fi