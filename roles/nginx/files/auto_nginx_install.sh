#!/bin/bash
#
# source install nginx

yum clean all &> /dev/null
yum makecache &> /dev/null
if [ $? -eq 0 ];then
	echo "yum源ok" >> /tmp/nginxinstall.txt
else
	echo "yum源error" >> /tmp/nginxinstall.txt
	exit 1
fi

yum -y install gcc gcc-c++ make pcre-devel openssl-devel &> /dev/null
if [ $? -eq 0 ];then
	echo "依赖包安装完成" >> /tmp/nginxinstall.txt
else
	echo "依赖包安装失败" >> /tmp/nginxinstall.txt
	exit 2
fi
useradd -M -s /sbin/nologin nginx

tar zxf /tmp/nginx-1.19.6.tar.gz -C /usr/src && cd /usr/src/nginx-1.19.6
if [ $? -eq 0 ];then
	echo "解压nginx安装包ok" >> /tmp/nginxinstall.txt
else
	echo "解压nginx安装包error" >> /tmp/nginxinstall.txt
	exit 3
fi
./configure --prefix=/usr/local/nginx --user=nginx --with-http_ssl_module --with-http_stub_status_module && make && make install &> /dev/null

if [ $? -eq 0 ];then
	echo "nginx安装成功" >> /tmp/nginxinstall.txt
else
	echo "nginx安装失败" >> /tmp/nginxinstall.txt
	exit 4
fi

ln -s /usr/local/nginx/sbin/* /usr/local/sbin/

