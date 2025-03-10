FROM debian:bullseye

# Install packages
RUN apt-get update && \
	apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

# Generate SSL certificate
RUN openssl req -x509 -sha256 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=DE/ST=BW/L=HB/O=42/OU=Student/CN=chorst.42.fr"

# Copy configuration file into the container
COPY ./conf/default /etc/nginx/sites-available/chorst.42.fr

# Create symbolic link for the configuration file
RUN ln -s /etc/nginx/sites-available/chorst.42.fr /etc/nginx/sites-enabled/

# Start NGINX in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]
