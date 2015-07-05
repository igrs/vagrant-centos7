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

# repo nginx
rpm -ivh http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.8.0-1.el7.ngx.x86_64.rpm

###############
# yum install #
###############

## nginx
cat <<'NGINXREPO' >/etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
NGINXREPO

yum -y install nginx
service nginx start
chkconfig nginx on

## mysql
yum -y install mysql mysql-devel mysql-server mysql-utilities
service mysqld start
chkconfig mysqld on

## git
yum -y install git

## php
yum -y install --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof

## composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
