#!/bin/bash

set -ex

##############
# repository #
##############

# repo epel
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# repo remi
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# repo mysql
rpm -ivh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

# repo postgresql(specifid 9.4)
rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm

###############
# yum install #
###############
## zsh
yum -y install zsh
usermod -s /bin/zsh vagrant

## apache
yum -y install httpd httpd-devel mod_ssl
systemctl start httpd.service
systemctl enable httpd.service

## mysql
yum -y install mysql mysql-devel mysql-server mysql-utilities
systemctl start mysqld.service
systemctl enable mysqld.service

## postgreql
yum -y install postgresql94-server postgresql94-devel postgresql94-contrib
/usr/pgsql-9.4/bin/postgresql94-setup initdb
systemctl start postgresql-9.4.service
systemctl enable postgresql-9.4.service

## git
yum -y install git

## php
yum -y install --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof

## composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## gcc
yum -y install gcc

## phalcon
git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install
cat <<'PHALCONINI' >/etc/php.d/phalcon.ini
extension=phalcon.so
PHALCONINI

## phalcon-devtools
cd /home/vagrant
echo '{"require": {"phalcon/devtools": "dev-master"}}' > composer.json
/usr/local/bin/composer install
mkdir -p /var/opt/phalcon/devtools
mv /home/vagrant/vendor/phalcon/devtools/* /var/opt/phalcon/devtools
ln -s /var/opt/phalcon/devtools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon

# firewall
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# conf
## apache
cp /vagrant/conf/httpd.conf /etc/httpd/conf/
chmod 644 /etc/httpd/conf/httpd.conf

# clean up
yum clean all
cd /home/vagrant/
rm composer.json
rm composer.lock
rm -fr vendor
rm -fr cphalcon
