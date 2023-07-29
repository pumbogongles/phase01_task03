#!/bin/bash
# Please do not remove this line. This command tells bash to stop executing on first error. 
set -e
rootpass="hitokiri"

#Linux System 20.04 - pablo@Ubuntu [needs sudo]
# Enter root 
echo "Entering Root"
sudo -s
$rootpass

# Installing nginx
echo "="
echo "=="
echo "======"
echo "==========="
echo "========N========="
echo "========G============="
echo "========I==============="
echo "========N====================="
echo "========X========================="
echo "====================================="
echo "========================================"
echo "============================================"
apt install nginx -y

# Installing mariaDB/mysql
echo "="
echo "=="
echo "======"
echo "==========="
echo "========M========="
echo "========Y============="
echo "========S==============="
echo "========Q====================="
echo "========L========================="
echo "====================================="
echo "========================================"
echo "============================================"
apt install mariadb-server -y

# Securing the mysql database
echo "="
echo "=="
echo "======"
echo "==========="
echo "========S========="
echo "========E============="
echo "========C==============="
echo "========U====================="
echo "========R========================="
echo "========E============================"
echo "========================================"
echo "============================================"
mysql_secure_installation <<EOF
""
Set root password? y
New Password: password
Re-enter new password: password
y
y
y
y
EOF

# Install php
apt install php-fpm php-mysql -y

#PART 1 COMPLETE