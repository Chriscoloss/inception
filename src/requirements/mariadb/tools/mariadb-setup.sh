#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Create the directory for the MariaDB socket if it doesn't exist
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize the MariaDB data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo -e "${YELLOW}[INCEPTION] Initializing database...${NC}"
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe --user=mysql &

# Wait until MariaDB is ready
until mysqladmin -u root ping -h localhost --silent; do
	echo -e "${YELLOW}[INCEPTION] Waiting for MariaDB to start...${NC}"
	sleep 1
done

echo -e "${GREEN}[INCEPTION] MariaDB started successfully.${NC}"

# Set the root password
mysql -u root -p"${DB_ROOT_PW}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PW}';"

# Check if the database exists
DB_EXISTS=$(mysql -u root -p${DB_ROOT_PW} -e "SHOW DATABASES LIKE '${DB_NAME}';" | grep "${DB_NAME}")
if [ -z "$DB_EXISTS" ]; then
	echo -e "${YELLOW}[INCEPTION] Creating database and user...${NC}"
	mysql -u root -p${DB_ROOT_PW} -e "CREATE DATABASE ${DB_NAME};"
	mysql -u root -p${DB_ROOT_PW} -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PW}';"
	mysql -u root -p${DB_ROOT_PW} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
	mysql -u root -p${DB_ROOT_PW} -e "FLUSH PRIVILEGES;"
else
	echo -e "${YELLOW}[INCEPTION] Database ${DB_NAME} already exists.${NC}"
fi

echo -e "${GREEN}[INCEPTION] MariaDB setup complete.${NC}"

# Stop MariaDB in background mode if necessary and start it in the foreground
mysqladmin -u root -p${DB_ROOT_PW} shutdown
exec mysqld_safe --user=mysql
