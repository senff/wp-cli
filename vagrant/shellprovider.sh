#!/usr/bin/env bash

# This script can be used to perform any sort of command line actions to setup your box. 
# This includes installing software, importing databases, enabling new sites, pulling from 
# remote servers, etc. 

# update
echo "########################"
echo "##### UPDATING APT #####"
echo "########################"
apt-get update

# Install Apache
echo "#############################"
echo "##### INSTALLING APACHE #####"
echo "#############################"
apt-get -y install apache2

# enable modrewrite
echo "#######################################"
echo "##### ENABLING APACHE MOD-REWRITE #####"
echo "#######################################"
a2enmod rewrite
a2enmod headers
a2enmod expires
a2enmod filter
a2enmod deflate
a2enmod ssl

# append AllowOverride to Apache Config File
echo "#######################################"
echo "##### CREATING APACHE CONFIG FILE #####"
echo "#######################################"
cp /vagrant/config/wordpress.conf /etc/apache2/sites-available/
cp /vagrant/config/phpmyadmin.conf /etc/apache2/sites-available/

echo "ServerName localhost" >> /etc/apache2/apache2.conf 

# Enabling Site
echo "##################################"
echo "##### Enabling Magento2 Site #####"
echo "##################################"
a2ensite wordpress.conf
a2ensite phpmyadmin.conf

# Setting Locales
echo "###########################"
echo "##### Setting Locales #####"
echo "###########################"
locale-gen en_US en_US.UTF-8 pl_PL pl_PL.UTF-8
dpkg-reconfigure locales

# Install MySQL 5.6
echo "############################"
echo "##### INSTALLING MYSQL #####"
echo "############################"
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server-5.6 mysql-client-5.6

# Install PHP 7.0
echo "##########################"
echo "#### INSTALLING PHP 7.0 ##"
echo "##########################"

apt-get -q -y  install python-software-properties
add-apt-repository ppa:ondrej/php
apt-get -q -y  update
apt-get -q -y  purge php5-fpm
apt-get -q -y  install php7.0-cli php7.0-common libapache2-mod-php7.0 php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mysql php7.0-bz2 php7.0-dev

echo "################################"
echo "#INSTALLING phpMyAdmin 4.5.3.1 #"
echo "################################"

wget https://files.phpmyadmin.net/phpMyAdmin/4.5.3.1/phpMyAdmin-4.5.3.1-all-languages.zip -P /var/www/html/
apt-get -q -y  install unzip
unzip /var/www/html/phpMyAdmin-4.5.3.1-all-languages.zip -d /var/www/html/
mv /var/www/html/phpMyAdmin-4.5.3.1-all-languages/ /var/www/html/phpmyadmin/

echo "################################"
echo "#### CONFIGURING phpMyAdmin ####"
echo "################################"
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
sed -i "s/\['AllowNoPassword'\] = false;/\['AllowNoPassword'\] = true;/g" /var/www/html/phpmyadmin/config.inc.php
/etc/init.d/apache2 restart

# PHP extensions
echo "########################"
echo "##### PHP EXTENSIONS ###"
echo "########################"
apt-get -q -y  install php-xml
apt-get -q -y  install php-mcrypt
apt-get -q -y  install php-intl
apt-get -q -y  install php-mbstring
apt-get -q -y  install php-zip
apt-get -q -y  install php-pear
apt-get -q -y  install libcurl3-openssl-dev
apt-get -q -y  install php7.0-mbstring php7.0-zip php7.0-xml php7.0-mcrypt php7.0-intl

# Install Git
echo "##########################"
echo "##### INSTALLING GIT #####"
echo "##########################"
apt-get -y install git

# Composer Installation
echo "###############################"
echo "##### INSTALLING COMPOSER #####"
echo "###############################"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer


# WordPress
echo "###################################"
echo "##### ALL THE WORDPRESS STUFF #####"
echo "###################################"

echo "--- CREATE DATABASE AND USER ---"
mysql -e "create database wordpress;"
mysql -e "create user wordpress@localhost identified by 'JRTsZneZyrc2';"
mysql -e "grant all privileges on wordpress.* TO 'wordpress'@'localhost';"
mysql -e "flush privileges;"

echo "--- INSTALL WP CLI ---"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

echo "--- INSTALLING WORDPRESS ---"
cd /var/www/html/wordpress
wp core download --allow-root
wp core config --dbname=wordpress --dbuser=wordpress --dbpass=JRTsZneZyrc2 --allow-root
wp core install --url="http://wp-cli.local" --title="WordPress Local" --admin_user="wp" --admin_password="wp" --admin_email="dale.cooper@fbi.gov" --allow-root

service apache2 restart

echo "#########################################################"
echo "##### ------------------ ALL DONE! ---------------- #####"
echo "##### ------ WORDPRESS IS TOTALLY INSTALLED. ------ #####"
echo "#########################################################"