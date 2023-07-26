#!/bin/bash
# Please do not remove this line. This command tells bash to stop executing on first error. 
set -e

# Update OS
echo "Updating OS"
sudo apt update
sudo apt upgrade -y
echo "OS update success!"

# Install Nginx
echo "Installing NGINX"
sudo apt install nginx -y
echo "NGINX install success!"

# Install MariaDB/MySQL
echo "Installing MariaDB/MySQL"
sudo apt install mariadb-server -y
echo "MariaDB/MySQL install success!"

# Securing the mysql installation
# mysqlpw=""
# echo "Secure MySQL server in progress"
# sudo mysql_secure_installation 
# echo $mysqlpw
# echo n
# echo y
# echo y
# echo y
# echo y

# Install PHP7.4
echo "Installing PHP7.4"
sudo apt install php7.4-fpm php7.4-mysql -y


# nginx config files are in /etc/nginx/sites-available
# default nginx webpage is in /var/www/html/

echo "Creating DB name, new user w/ password" 
# Defining variables
user="admin"
pass="password123"
dbname="db_wordpress"

# Download Wordpress and unpack
cd /var/www/html/

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
cd wordpress

# Create DB for wordpress
echo "Creating a Database for wordpress"
sudo mysql -e "CREATE DATABASE $dbname default character set utf8 collate utf8_unicode_ci;"
sudo mysql -e "GRANT ALL ON $dbname.* TO '$user'@'localhost' IDENTIFIED BY '$pass';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Copy and change wp-config
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/$dbname/g" wp-config.php
sudo sed -i "s/username_here/$user/g" wp-config.php
sudo sed -i "s/password_here/$pass/g" wp-config.php

# Changing sites-available info
cd /etc/nginx/sites-available
sudo touch default
sudo -s
sudo cat > default <<EOF
server{
listen 80 default_server;
listen [::]:80 default_server;

root /var/www/html/wordpress;

index index.php index.html index.htm;

server_name localhost;

location /{
try_files $uri $uri/ =404;
}
error_page 404 /404.html;
error_page 500 502 503 504 50x.html;
location = /50x.html {
root /usr/share/nginx.html;
}
location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/run/php/php7.4-fpm.sock;
}
}
EOF
exit

sudo systemctl restart nginx