FROM debian:bullseye

# Installiere MariaDB und lösche unnötige Dateien zur Platzersparnis
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Konfigurationsdatei kopieren
COPY ./conf/50-server.cnf /etc/mysql/mariadb.cnf

# Setup-Skript kopieren und ausführbar machen
COPY --chmod=0755 ./tools/mariadb-setup.sh /usr/local/bin/mariadb-setup.sh

# Standardbefehl setzen
CMD ["/usr/local/bin/mariadb-setup.sh"]
