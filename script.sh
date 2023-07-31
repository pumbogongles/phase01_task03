set -e
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
echo "End of Document"