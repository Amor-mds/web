#!/bin/bash
#
# source git nginx

yum clean all &> /dev/null
yum makecache &> /dev/null
if [ $? -eq 0 ];then
	echo "yum源ok" >> /tmp/phpinstall.txt
else
	echo "yum源error" >> /tmp/phpinstall.txt
	exit 1
fi

yum -y install gd libxml2-devel libjpeg-devel libpng-devel
if [ $? -eq 0 ];then
	echo "依赖包安装完成" >> /tmp/phpinstall.txt
else
	echo "依赖包安装失败" >> /tmp/phpinstall.txt
	exit 2
fi

useradd -M -s /sbin/nologin nginx
tar zxf /tmp/php-5.5.16.tar.gz -C /usr/src && cd /usr/src/php-5.5.16
if [ $? -eq 0 ];then
	echo "解压安装包ok" >> /tmp/phpinstall.txt
else
	echo "解压安装包error" >> /tmp/phpinstall.txt
	exit 3
fi

./configure --prefix=/usr/local/php5 --with-gd --with-zlical-php5 --with-gd --with-zlib --with-mysql=mysqlnd --with-config-file=/usr/local/php5 --enable-mbstring --enable-fpm --with-jpeg-dir=/usr/lib && make && make install &> /dev/null
if [ $? -eq 0 ];then
	echo "安装成功" >> /tmp/phpinstall.txt
else
	echo "安装失败" >> /tmp/phpinstall.txt
	exit 4
fi

cp php.ini-development /usr/local/php5/php.ini
ln -s /usr/local/php5/bin/* /usr/local/bin/
ln -s /usr/local/php5/sbin/* /usr/local/sbin/
cd /usr/local/php5/etc/
cp php-fpm.conf.default php-fpm.conf

