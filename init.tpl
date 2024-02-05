#!/bin/bash
uptime >> "/var/start.txt"

sudo apt update

sudo apt install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld

uptime >> "/var/step-0.txt"

sudo apt install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

uptime >> "/var/step-1.txt"

DB_USER="ecomuser"
DB_PASSWORD="ecompassword"
DB_NAME="ecomdb"

# MySQL/MariaDB commands
mysql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Database '$DB_NAME' created, user '$DB_USER' granted privileges."

cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF

sudo mysql < db-load-script.sql

uptime >> "/var/step-2.txt"

sudo apt install -y httpd php php-mysqlnd
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

sudo systemctl start httpd
sudo systemctl enable httpd

sudo apt install -y git
sudo git clone https://github.com/Md-Aashiqq/iac_demo.git /var/www/html/

sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

uptime >> "/var/step-4.txt"

# Install Apache, PHP, and PHP MySQL extension
sudo apt install -y apache2 php php-mysql

# Open port 80 in the firewall
sudo ufw allow 80/tcp

# Enable UFW (Uncomplicated Firewall)
sudo ufw enable

# Replace 'httpd' with 'apache2' in the configuration file
sudo sed -i 's/index.html/index.php/g' /etc/apache2/apache2.conf

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Install Git
sudo apt install -y git

# Clone the repository
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

# Replace IP address in index.php
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

# Record the system uptime in a file
uptime >> "/var/step-4.txt"
# sudo apt update -y 
# sudo apt install -y nginx
# systemctl enable nginx
# systemctl start nginx
# echo "Hello World" > /var/www/html/index.html

echo "Success" >> /var/sdf.txt
uptime >> "/var/end.txt"