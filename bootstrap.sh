yum clean all
yum -y upgrade

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

yum -y install httpd
systemctl enable httpd
systemctl start httpd
rm -rf /var/www/html
ln -s /vagrant /var/www/html
setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

yum -y install mariadb-server
systemctl enable mariadb.service
systemctl start mariadb.service
echo "delete from user where user = '';" | mysql mysql
echo "drop database test;" | mysql
echo "grant all privileges on *.* to 'admin'@'%' identified by '1admin1' with grant option;" | mysql
echo "flush privileges;" | mysql

yum -y install php55w php55w-mysql php55w-pecl-xdebug
cat << _EOF_ >> /etc/php.d/xdebug.ini
xdebug.remote_enable = 1
xdebug.remote_handler = dbgp
xdebug.remote_host = 10.0.2.2
xdebug.remote_port = 9000
xdebug.profiler_enable = 0
xdebug.profiler_output_dir = "/var/log/xdebug"
xdebug.overload_var_dump = 0
_EOF_
systemctl restart httpd.service

#Vhosts
cat << _EOF_ >> /etc/httpd/conf/httpd.conf
<VirtualHost *:80>
	ServerName frontend.local
	DocumentRoot /var/www/html/frontend
</VirtualHost>
<VirtualHost *:80>
	ServerName backend.local
	DocumentRoot /var/www/html/backend
</VirtualHost>
_EOF_
systemctl restart httpd.service
