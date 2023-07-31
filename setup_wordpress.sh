#!/bin/bash
# Please do not remove this line. This command tells bash to stop executing on first error. 
set -e

# Defining variables
user="admin"
pass="password123"
dbname="db_wordpress"

# Update OS
echo "Updating OS"
apt update
apt upgrade -y
echo "OS update success!"

# Install Nginx
echo "Installing NGINX, MariaDB, PHP"
sudo apt install nginx mariadb-server php-fpm php-mysql -y
echo "NGINX install success!"
echo "MariaDB/MySQL install success!"
echo "PHP7.4 install success!"


# Securing the mysql installation
echo "Secure MySQL server in progress"
mysql_secure_installation <<EOF

n
y
y
y
y
EOF

# nginx config files are in /etc/nginx/sites-available
# default nginx webpage is in /var/www/html/

# Download Wordpress and unpack
cd /var/www/html/
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cd wordpress

# Create DB for wordpress
echo "Creating a Database for wordpress"
mysql -e "CREATE DATABASE $dbname default character set utf8 collate utf8_unicode_ci;"
mysql -e "GRANT ALL ON $dbname.* to '$user'@'localhost' IDENTIFIED BY '$password';"
mysql -e "FLUSH PRIVILEGES;"

# Copy and change wp-config
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$dbname/g" wp-config.php
sed -i "s/username_here/$user/g" wp-config.php
sed -i "s/password_here/$password/g" wp-config.php

# Changing sites-available info
cd /etc/nginx/sites-available
touch default
cat > default <<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html/wordpress;

	index index.php index.html index.htm;

	server_name localhost;

	location / {
		try_files \$uri \$uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;

		fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
	}

}
EOF
systemctl restart nginx
echo "Please try going to localhost now"
