# Install wordpress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar latest.tar.gz

user="admin"
pass="password123"
dbname="db_wordpress"
# Create mysql DB and user privileges
mysql -e "CREATE DATABASE $db_wordpress default character set utf8 collate utf8_unicode_ci;"
mysql -e "GRANT ALL ON $dbname.* to '$user'@'localhost' IDENTIFIED BY '$pass';"
mysql -e "FLUSH PRIVILEGES;"

# Make a copy of wp-config-sample.php and name it wp-config.php
cp wp-config-sample.php wp-config.php

# Rename the insides, change database_name_here, username_here and password_here into established info
sed -i "s/database_name_here/$dbname/g" wp-config.php
sed -i "s/username_here/$user/g" wp-config.php
sed -i "s/password_here/$pass/g" wp-config.php

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
try_files $uri $uri/ =404;
}		
location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
}
}
EOF

sudo systemctl restart nginx