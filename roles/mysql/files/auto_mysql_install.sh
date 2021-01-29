#!/bin/bash
#
# source git nginx

yum clean all &> /dev/null
yum makecache &> /dev/null
if [ $? -eq 0 ];then
	echo "yum源ok" >> /tmp/mysqlinstall.txt
else
	echo "yum源error" >> /tmp/mysqlinstall.txt
	exit 1
fi

yum -y install gcc gcc-c++ ncurses ncurses-devel
if [ $? -eq 0 ];then
	echo "依赖包安装完成" >> /tmp/mysqlinstall.txt
else
	echo "依赖包安装失败" >> /tmp/mysqlinstall.txt
	exit 2
fi

rpm -qa | grep "mariadb"
rpm -e mariadb-libs-5.5.52-1.el7.x86_64 --nodeps

tar zxf /tmp/cmake-2.8.6.tar.gz -C /usr/src && cd /usr/src/cmake-2.8.6
./configure && gmake && gmake install &> /dev/null
if [ $? -eq 0 ];then
	echo "cmake安装成功"  >> /tmp/mysqlinstall.txt
else
	echo "cmake安装失败" >> /tmp/mysqlinstall.txt
	exit 3
fi

tar zxf /tmp/mysql-5.5.55.tar.gz -C /usr/src && cd /usr/src/mysql-5.5.55
if [ $? -eq 0 ];then
	echo "解压安装包ok" >> /tmp/mysqlinstall.txt
else
	echo "解压安装包error" >> /tmp/mysqlinstall.txt
	exit 4
fi
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=all -DSYSCONFDIR=/etc/ && make && make install
if [ $? -eq 0 ];then
	echo "mysql安装成功" >> /tmp/mysqlinstall.txt
else
	echo "mysql安装失败" >> /tmp/mysqlinstall.txt
	exit 5
fi

cp support-files/my-medium.cnf /etc/my.conf
cp support-files/mysql.server /etc/init.d/mysqld
ln -s /usr/local/mysql/bin/* /usr/local/bin/
useradd  -M -s /sbin/nologin mysql
chown -R mysql /usr/local/mysql/

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/ --user=mysql
if [ $? -eq 0 ];then
	echo "mysql初始化成功" >> /tmp/mysqlinstall.txt
else
	echo "mysql初始化失败" >> /tmp/mysqlinstall.txt
	exit 5
fi

chmod +x /etc/init.d/mysqld

