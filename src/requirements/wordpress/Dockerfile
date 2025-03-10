FROM debian:bullseye

# System-Update und Installation der notwendigen Pakete
RUN apt-get update -y && \
	apt-get install -y curl php-fpm php-mysql mariadb-client && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	wp cli update

# Kopieren der Konfigurationsdatei für PHP
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Kopieren des Scripts, das den WordPress-Initialisierungsprozess übernimmt
COPY --chmod=0755 ./tools/init_wp.sh /usr/local/bin/init_wp.sh

# Setzen der Berechtigungen und Festlegen des EntryPoints
RUN chmod +x /usr/local/bin/init_wp.sh

# Einstiegspunkt des Containers (wird das WordPress-Setup ausführen)
ENTRYPOINT ["/usr/local/bin/init_wp.sh"]
