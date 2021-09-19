#!/bin/bash
#筑梦FAS系统破解shell本
#何以潇这种狗心里有点逼数吗
#知速给你的源码哪来的没点逼数？
function fhqcz() {
	#关闭SELinux
	setenforce 0 >/dev/null 2>&1
	if [ ! -f /etc/selinux/config ]; then
	echo "警告！SELinux关闭失败，请自行检查SELinux关键模块是否存在！脚本停止！"
	exit
	fi
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	iptables -F
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	iptables -A INPUT -s 127.0.0.1/32  -j ACCEPT
	iptables -A INPUT -d 127.0.0.1/32  -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport $Apacheport -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 440 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 3389 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 137 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 137 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1194 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1195 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1196 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1197 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 137 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 138 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -t nat -A PREROUTING -p udp --dport 138 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 137 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1194 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1195 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1196 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1197 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING --dst 10.8.0.1 -p udp --dport 53 -j DNAT --to-destination 10.8.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.9.0.1 -p udp --dport 53 -j DNAT --to-destination 10.9.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.10.0.1 -p udp --dport 53 -j DNAT --to-destination 10.10.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.11.0.1 -p udp --dport 53 -j DNAT --to-destination 10.11.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.12.0.1 -p udp --dport 53 -j DNAT --to-destination 10.12.0.1:5353
	iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT  
	iptables -P INPUT DROP
	iptables -t nat -A POSTROUTING -s 10.0.0.0/24  -j MASQUERADE
	iptables -t nat -A POSTROUTING -j MASQUERADE
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	echo
	echo "防火墙已重置完成！"
}
function ly01() {
#关闭SELinux
setenforce 0 >/dev/null 2>&1
if [ ! -f /etc/selinux/config ]; then
	#echo "SELinux检测不到的，关闭不掉的，或关闭失败的，请自行联系破解作者解决！"
	echo "警告！SELinux关闭失败，请自行检查SELinux关键模块是否存在！脚本停止！"
	exit
fi
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#下载IP路由转发配置
rm -rf /etc/sysctl.conf
wget -q ${downloadhost}sysctl.conf -P /etc
if [ ! -f /etc/sysctl.conf ]; then
	echo "警告！IP路由转发配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit
fi
sysctl -p /etc/sysctl.conf >/dev/null 2>&1
#停止firewalld防火墙
systemctl stop firewalld.service >/dev/null 2>&1
#禁用firewalld防火墙
systemctl disable firewalld.service >/dev/null 2>&1
#尝试停止iptables防火墙
systemctl stop iptables.service >/dev/null 2>&1
#安装iptables防火墙
yum -y install iptables iptables-services >/dev/null 2>&1
#启动iptables防火墙
systemctl start iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables启动失败！请手动重启IPtables查看失败原因！脚本停止！"
exit
fi
#清空iptables防火墙配置
iptables -F
service iptables save >/dev/null 2>&1
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
exit
fi
iptables -A INPUT -s 127.0.0.1/32  -j ACCEPT
iptables -A INPUT -d 127.0.0.1/32  -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport $lyApacheport -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 440 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3389 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1194 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1195 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1196 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1197 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 138 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 137 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 137 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 138 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -p udp --dport 138 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 137 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1194 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1195 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1196 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1197 -j REDIRECT --to-ports 53
#iptables -t nat -I PREROUTING -p udp --dport 5353 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING --dst 10.8.0.1 -p udp --dport 53 -j DNAT --to-destination 10.8.0.1:5353
iptables -t nat -A PREROUTING --dst 10.9.0.1 -p udp --dport 53 -j DNAT --to-destination 10.9.0.1:5353
iptables -t nat -A PREROUTING --dst 10.10.0.1 -p udp --dport 53 -j DNAT --to-destination 10.10.0.1:5353
iptables -t nat -A PREROUTING --dst 10.11.0.1 -p udp --dport 53 -j DNAT --to-destination 10.11.0.1:5353
iptables -t nat -A PREROUTING --dst 10.12.0.1 -p udp --dport 53 -j DNAT --to-destination 10.12.0.1:5353
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT
iptables -P INPUT DROP
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.9.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.11.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.12.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -j MASQUERADE
service iptables save >/dev/null 2>&1
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
exit;0
fi
systemctl enable iptables.service >/dev/null 2>&1
}
function ly02() {
#--force --nodeps
#安装epel仓库
yum -y install epel-release
#yum -y install openssl openssl-libs openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig  gawk tar zip unzip  net-tools psmisc gcc httpd libxml2 libxml2-devel  bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel dnsmasq iptables iptables-services
#安装筑梦官方所需环境
yum -y install telnet avahi openssl openssl-libs openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig gawk tar zip unzip net-tools psmisc gcc pkcs11-helper mariadb mariadb-server httpd libxml2 libxml2-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel dnsmasq jre-1.7.0-openjdk crontabs
#安装PHP环境（这里使用的是第三方PHP安装源，并非筑梦官方安装源，此项并不影响正常安装使用使用）
#安装PHP7.0
rpm -Uvh ${downloadhost}webtatic-release.rpm
yum install php70w php70w-fpm php70w-bcmath php70w-cli php70w-common php70w-dba php70w-devel php70w-embedded php70w-enchant php70w-gd php70w-imap php70w-ldap php70w-mbstring php70w-mcrypt php70w-mysqlnd php70w-odbc php70w-opcache php70w-pdo php70w-pdo_dblib php70w-pear.noarch php70w-pecl-apcu php70w-pecl-apcu-devel php70w-pecl-imagick php70w-pecl-imagick-devel php70w-pecl-mongodb php70w-pecl-redis php70w-pecl-xdebug php70w-pgsql php70w-xml php70w-xmlrpc php70w-intl php70w-mcrypt --nogpgcheck php-fedora-autoloader php-php-gettext php-tcpdf php-tcpdf-dejavu-sans-fonts php70w-tidy -y
#安装openvpn.rpm所需环境！
rpm -Uvh ${downloadhost}liblz4-1.8.1.2-alt1.x86_64.rpm
#这里使用的是非筑梦官方的openvpn源，由于筑梦官方的openvpn2.4.3的rpm包找不到，只能采用最新版的2.4.6的rpm包
rpm -Uvh ${downloadhost}openvpn-2.4.6-1.el7.x86_64.rpm
}
function ly03() {
systemctl start mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB初始化失败！请手动启动MariaDB查看失败原因！脚本停止！"
exit;0
fi
mysqladmin -uroot password "$lysqlpass" #创建数据库密码
mysql -uroot -p$lysqlpass -e "create database vpndata;" #创建vpndata数据表
#mysql -uroot -p$lysqlpass -e "drop database test;" #删除默认test数据库
#mysql -uroot -p$lysqlpass -e "CREATE USER 'vpndata'@'localhost';SET PASSWORD FOR 'vpndata'@'localhost' = PASSWORD('dnfbjbvad16816461sd');GRANT All ON *.* TO 'vpndata'@'localhost';"
systemctl restart mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
exit;0
fi
systemctl enable mariadb.service >/dev/null 2>&1
}
function ly04() {
#修改Apache端口  修改主机名
sed -i "s/#ServerName www.example.com:80/ServerName localhost:$lyApacheport/g" /etc/httpd/conf/httpd.conf
sed -i "s/Listen 80/Listen $lyApacheport/g" /etc/httpd/conf/httpd.conf
setenforce 0 >/dev/null 2>&1
systemctl start httpd.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Apache启动失败！请手动启动Apache查看失败原因！脚本停止！"
exit;0
fi
systemctl enable httpd.service >/dev/null 2>&1
#由于PHP问题，需要添加第三方数据库支持，请勿删除，否则phpMyAdmin无法打开！
cat >> /etc/php.ini <<EOF
extension=php_mcrypt.dll
extension=php_mysqli.dll
EOF
systemctl start php-fpm.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！PHP启动失败！请手动启动PHP查看失败原因！脚本停止！"
exit;0
fi
systemctl enable php-fpm.service >/dev/null 2>&1
}
function ly05() {
if [ ! -d /etc/openvpn ]; then
	echo "警告！OpenVPN安装失败，请自行检查rpm包下载源是否可用！脚本停止！"
	exit;0
fi
cd /etc/openvpn && rm -rf /etc/openvpn/*
wget -q ${downloadhost}openvpn.zip
if [ ! -f /etc/openvpn/openvpn.zip ]; then
	echo "警告！OpenVPN配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o openvpn.zip >/dev/null 2>&1
rm -rf openvpn.zip && chmod 0777 -R /etc/openvpn
sed -i "s/newpass/"$lysqlpass"/g" /etc/openvpn/auth_config.conf
sed -i "s/服务器IP/"$IP"/g" /etc/openvpn/auth_config.conf
systemctl enable openvpn@server1194.service >/dev/null 2>&1
systemctl enable openvpn@server1195.service >/dev/null 2>&1
systemctl enable openvpn@server1196.service >/dev/null 2>&1
systemctl enable openvpn@server1197.service >/dev/null 2>&1
systemctl enable openvpn@server-udp.service >/dev/null 2>&1
}
function ly06() {
if [ ! -f /etc/dnsmasq.conf ]; then
	echo "警告！dnsmasq安装失败，请自行检查dnsmasq是否安装正确！脚本停止！"
	exit;0
fi
rm -rf /etc/dnsmasq.conf
wget -q ${downloadhost}dnsmasq.conf -P /etc && chmod 0777 /etc/dnsmasq.conf
if [ ! -f /etc/dnsmasq.conf ]; then
	echo "警告！dnsmasq配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
systemctl enable dnsmasq.service >/dev/null 2>&1
}
function ly07() {
###安装数据库自动备份
systemctl start crond.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Crond启动失败！请手动启动Crond查看失败原因！脚本停止！"
exit;0
fi
crontab -l > /tmp/crontab.$$
echo '*/60 * * * * /etc/openvpn/sqlbackup' >> /tmp/crontab.$$
crontab /tmp/crontab.$$
systemctl restart crond.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Crond重启失败！请手动启动Crond查看失败原因！脚本停止！"
exit;0
fi
systemctl enable crond.service >/dev/null 2>&1
}
function web() {
#安装web云端
rm -rf /var/www/* && cd /var/www && wget -q ${downloadhost}fas_web.zip
if [ ! -f /var/www/fas_web.zip ]; then
	echo "警告！FAS-WEB配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o fas_web.zip >/dev/null 2>&1 && rm -rf fas_web.zip && chmod 0777 -R /var/www/html
#导入数据库vpndata表数据
sed -i "s/lyfasadmin/"$lyadminuser"/g" /var/www/vpndata.sql
sed -i "s/lyfaspass/"$lyadminpass"/g" /var/www/vpndata.sql
sed -i "s/服务器IP/"$IP"/g" /var/www/vpndata.sql
mysql -uroot -p$lysqlpass vpndata < /var/www/vpndata.sql
rm -rf /var/www/vpndata.sql
#修改数据库密码
sed -i "s/newpass/"$lysqlpass"/g" /var/www/html/config.php
#添加本地随机密钥
echo "$lyadminbendipass">>/var/www/auth_key.access
}
function sbin() {
#新建带宽监控数据文件夹
mkdir /etc/rate.d/ && chmod -R 0777 /etc/rate.d/
#更新命令指示符
cd /root&&wget -q ${downloadhost}res.zip
if [ ! -f /root/res.zip ]; then
	echo "警告！FAS-res配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o res.zip >/dev/null 2>&1 && chmod -R 0777 /root && rm -rf /root/res.zip
mv /root/res/fas.service /lib/systemd/system/fas.service && chmod -R 0777 /lib/systemd/system/fas.service && systemctl enable fas.service >/dev/null 2>&1
cd /bin && wget -q ${downloadhost}bin.zip
if [ ! -f /bin/bin.zip ]; then
	echo "警告！FAS命令指示符配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o bin.zip >/dev/null 2>&1 && rm -rf /bin/bin.zip && chmod -R 0777 /bin
#新建自定义屏蔽host文件
echo 'FAS系统自定义屏蔽host文件
'>>/etc/fas_host && chmod 0777 /etc/fas_host
}
function qidongya() {
#启动所有服务
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
exit;0
fi
systemctl restart mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
exit;0
fi
systemctl restart httpd.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Apache启动失败！请手动启动Apache查看失败原因！脚本停止！"
exit;0
fi
systemctl restart php-fpm.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！PHP启动失败！请手动启动PHP查看失败原因！脚本停止！"
exit;0
fi
systemctl restart dnsmasq.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！DNSmasq启动失败！请手动启动DNSmasq查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1194.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1194服务启动失败！请手动启动openvpn@server1194服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1195.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1195服务启动失败！请手动启动openvpn@server1195服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1196.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1196服务启动失败！请手动启动openvpn@server1196服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1197.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1197服务启动失败！请手动启动openvpn@server1197服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server-udp.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server-udp服务启动失败！请手动启动openvpn@server-udp服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart fas.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Fas服务启动失败！请手动启动Fas服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart crond.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Crond重启失败！请手动启动Crond查看失败原因！脚本停止！"
exit;0
fi
dhclient >/dev/null 2>&1
vpn restart >/dev/null 2>&1
}
function Installation() {
#安装单独APP制作环境
yum install jre-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
}
function app1() {
rm -rf /APP
mkdir /APP >/dev/null 2>&1
cd /APP
wget -q ${downloadhost}fas.apk&&wget -q ${downloadhost}apktool.jar&&java -jar apktool.jar d fas.apk >/dev/null 2>&1&&rm -rf fas.apk
sed -i 's/demo.dingd.cn:80/'${llwsIP}:${lyApacheport}'/g' `grep demo.dingd.cn:80 -rl /APP/fas/smali/net/openvpn/openvpn/`
sed -i 's/叮咚流量卫士/'${llwsname}'/g' "/APP/fas/res/values/strings.xml"
sed -i 's/net.dingd.vpn/'${llwsbaoming}'/g' "/APP/fas/AndroidManifest.xml"
java -jar apktool.jar b fas >/dev/null 2>&1
wget -q ${downloadhost}signer.zip&&unzip -o signer.zip >/dev/null 2>&1
mv /APP/fas/dist/fas.apk /APP/fas.apk
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/fas.apk /APP/fas_sign.apk >/dev/null 2>&1
cp -rf /APP/fas_sign.apk /root/fasapp_by_ly.apk
rm -rf /APP
if [ ! -f /root/fasapp_by_ly.apk ]; then
echo
echo "筑梦FAS系统APP制作失败！"
echo
echo "请自行前往烟雨如花交流群获取手动对接APP源！"
echo
echo "烟雨如花交流群：259282245    欢迎你的加入！"
exit;0
fi
}
function app() {
#制作APP
rm -rf /APP
mkdir /APP >/dev/null 2>&1
cd /APP
wget -q ${downloadhost}fas.apk&&wget -q ${downloadhost}apktool.jar&&java -jar apktool.jar d fas.apk >/dev/null 2>&1&&rm -rf fas.apk
sed -i 's/demo.dingd.cn:80/'${llwsIP}:${lyApacheport}'/g' `grep demo.dingd.cn:80 -rl /APP/fas/smali/net/openvpn/openvpn/`
sed -i 's/叮咚流量卫士/'${llwsname}'/g' "/APP/fas/res/values/strings.xml"
sed -i 's/net.dingd.vpn/'${llwsbaoming}'/g' "/APP/fas/AndroidManifest.xml"
java -jar apktool.jar b fas >/dev/null 2>&1
wget -q ${downloadhost}signer.zip&&unzip -o signer.zip >/dev/null 2>&1
mv /APP/fas/dist/fas.apk /APP/fas.apk
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/fas.apk /APP/fas_sign.apk >/dev/null 2>&1
cp -rf /APP/fas_sign.apk /var/www/html/fasapp_by_ly.apk
rm -rf /APP
if [ ! -f /var/www/html/fasapp_by_ly.apk ]; then
echo
echo "筑梦FAS系统APP制作失败！"
echo
echo "请自行前往烟雨如花交流群获取手动对接APP源！"
echo
echo "烟雨如花交流群：259282245    欢迎你的加入！"
fi
}
function zhuji() {
	clear
	echo
	read -p "请输入本机数据库地址(localhost): " lysqlip
	if [ -z "$lysqlip" ];then
	lysqlip=localhost
	fi
	
	echo
	read -p "请输入本机数据库端口(3306): " lysqlport
	if [ -z "$lysqlport" ];then
	lysqlport=3306
	fi
	
	echo
	read -p "请输入本机数据库账号(root): " lysqluser
	if [ -z "$lysqluser" ];then
	lysqluser=root
	fi
	
	echo
	read -p "请输入本机数据库密码: " lysqlpass
	if [ -z "$lysqlpass" ];then
	lysqlpass=
	fi
	
	echo
	echo "正在为您的系统进行负载，请稍等......"
	sleep 3
	SQL_RESULT=`mysql -h${lysqlip} -P${lysqlport} -u${lysqluser} -p${lysqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "数据库连接失败，请检查您的数据库密码后重试，脚本停止！";
	exit;
	fi
	
	iptables -A INPUT -p tcp -m tcp --dport $lysqlport -j ACCEPT
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	
	mysql -h${lysqlip} -P${lysqlport} -u${lysqluser} -p${lysqlpass} <<EOF
grant all privileges on *.* to '${lysqluser}'@'%' identified by '${lysqlpass}' with grant option;
flush privileges;
EOF
	systemctl restart mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
	exit
	fi
	
	sleep 5
	echo
	echo "已成功为您的系统进行负载！您可以在任何搭载FAS系统机器上对接至本服务器！"
	
}
function port123() {
clear
echo -e "请选择协议类型（本程序仅适用于FAS系统）："
echo -e "1. TCP 代理端口"
echo -e "2. UDP 直连端口（将转发至53端口）"
read install_type

echo -n "请输入端口号(0-65535):"
read port


if [ $install_type == 1 ];then
	/root/res/proxy.bin -l $port -d
	read has < <(cat /etc/sysconfig/iptables | grep "tcp \-\-dport $port \-j ACCEPT" )
	if [ -z "$has" ];then
		iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT
		service iptables save
		echo -e "[添加tcp $port 至防火墙白名单]"
	fi
	read has2 < <(cat /root/res/portlist.conf | grep "port $port tcp" )
	if [ -z "$has2" ];then
		echo -e "port $port tcp">>/root/res/portlist.conf
	fi
	echo -e "[已经成功添加代理端口]"
else
	read has < <(cat /etc/sysconfig/iptables | grep "udp \-\-dport $port \-j ACCEPT" )
	if [ -z "$has" ];then
		iptables -A INPUT -p udp -m udp --dport $port -j ACCEPT
		service iptables save
		echo -e "[添加tcp $port 至防火墙白名单]"
	fi
	iptables -t nat -A PREROUTING -p udp --dport $port -j REDIRECT --to-ports 53 && service iptables save
	echo -e "[已将此端口转发至53 UDP端口]"
fi
echo "感谢使用 再见！"
exit;0
}
function fuji() {
	clear
	echo
	read -p "请输入本机IP: " lybenjiip
	if [ -z "$lybenjiip" ];then
	lybenjiip=
	fi
	
	echo
	read -p "请输入主机IP: " lysqlip
	if [ -z "$lysqlip" ];then
	lysqlip=
	fi
	
	echo
	read -p "请输入主机数据库端口: " lysqlport
	if [ -z "$lysqlport" ];then
	lysqlport=
	fi
	
	echo
	read -p "请输入主机数据库账号: " lysqluser
	if [ -z "$lysqluser" ];then
	lysqluser=
	fi
	
	echo
	read -p "请输入主机数据库密码: " lysqlpass
	if [ -z "$lysqlpass" ];then
	lysqlpass=
	fi
	
	echo
	echo "正在为您的系统进行负载，请稍等......"
	sleep 3
	SQL_RESULT=`mysql -h${lysqlip} -P${lysqlport} -u${lysqluser} -p${lysqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "连接至主机数据库失败，请检查您的主机数据库密码后重试，脚本停止！";
	exit;
	fi

	rm -rf /etc/openvpn/auth_config.conf
	echo '#!/bin/bash
#兼容配置文件 此文件格式既可以适应shell也可以适应FasAUTH，但是这里不能使用变量，也不是真的SHELL文件，不要写任何shell在这个文件
#FAS监控系统配置文件
#请谨慎修改
#数据库地址
mysql_host='$lysqlip'
#数据库用户
mysql_user='$lysqluser'
#数据库密码
mysql_pass='$lysqlpass'
#数据库端口
mysql_port='$lysqlport'
#数据库表名
mysql_data=vpndata
#本机地址
address='$lybenjiip'
#指定异常记录回收时间 单位s 600即为十分钟
unset_time=600
#删除僵尸记录地址
del="/root/res/del"

#进程1监控地址
status_file_1="/var/www/html/openvpn_api/online_1194.txt 7075 1194 tcp-server"
status_file_2="/var/www/html/openvpn_api/online_1195.txt 7076 1195 tcp-server"
status_file_3="/var/www/html/openvpn_api/online_1196.txt 7077 1196 tcp-server"
status_file_4="/var/www/html/openvpn_api/online_1197.txt 7078 1197 tcp-server"
status_file_5="/var/www/html/openvpn_api/user-status-udp.txt 7079 53 udp"
#睡眠时间
sleep=3'>/etc/openvpn/auth_config.conf && chmod -R 0777 /etc/openvpn/auth_config.conf
rm -rf /var/www/html/config.php
echo '<?php
/* 本文件由系统自动生成 如非必要 请勿修改 */
define("_host_","'$lysqlip'");
define("_user_","'$lysqluser'");
define("_pass_","'$lysqlpass'");
define("_port_","'$lysqlport'");
define("_ov_","vpndata");
define("_openvpn_","openvpn");
define("_iuser_","iuser");
define("_ipass_","pass");
define("_isent_","isent");
define("_irecv_","irecv");
define("_starttime_","starttime");
define("_endtime_","endtime");
define("_maxll_","maxll");
define("_other_","dlid,tian");
define("_i_","i");'>/var/www/html/config.php && chmod -R 0777 /var/www/html/config.php
	systemctl stop mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！MariaDB停止失败！请手动停止MariaDB查看失败原因！脚本停止！"
	exit;0
	fi
	
	sleep 5
	echo
	echo "已成功为您的系统进行负载！主机IP为："$lysqlip"！"
	echo 
	echo "副机系统请前往shell控制台输入 unfas、unsql 关闭后台登录权限，以防被不法份子入侵系统！"
	echo
	echo "请您及时前往主机FAS后台管理添加本机，本机IP: "$lybenjiip""
}
function menufuzai() {
	clear
	echo
	echo -e "************************************************"
	echo -e "           欢迎使用FAS系统快速负载助手          "
	echo -e "************************************************"
	echo -e "请选择："
	echo
	echo -e "\033[36m 1、主机开启远程连接权限\033[0m \033[31m（主机只需开启一次，后续直接副机对接主机即可）\033[0m"
	echo
	echo -e "\033[36m 2、副机连接主机数据库\033[0m \033[31m（在副机执行，每个机子无限负载主机，仅生效最后一次负载的机器）\033[0m"
	echo
	echo -e "\033[36m 3、退出脚本！\033[0m"
	echo
	echo 
	read -p " 请输入安装选项并回车: " a
	echo
	echo
	k=$a

	if [[ $k == 1 ]];then
	downloadhostxuanzhe
	zhuji
	exit;0
	fi
	
	if [[ $k == 2 ]];then
	downloadhostxuanzhe
	fuji
	exit;0
	fi
	
	if [[ $k == 3 ]];then
	echo
	echo "感谢您的使用，再见！"
	exit;0
	fi
	
	echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
	exit;0
}
function done1() {
#完成安装
#锁定数据库后台
unsql >/dev/null 2>&1
clear
echo "---------------------------------------------"
echo "---------------------------------------------"
echo "恭喜，您已经安装完毕。"
echo "控制台: http://"$IP":"$lyApacheport"/admin/"
echo "账号: "$lyadminuser" 密码: "$lyadminpass""
echo "控制台随机本地密钥: "$lyadminbendipass""
echo "内置数据库管理: http://"$IP":"$lyApacheport"/phpMyAdmin/"
echo "---------------------------------------------"
echo "数据库账户: root   密码: "$lysqlpass"      "
echo "代理控制台: http://"$IP":"$lyApacheport"/daili"
echo "---------------------------------------------"
echo "常用指令: "
echo "重启VPN vpn restart     FAS后台开启：onfas   "
echo "启动VPN vpn start       FAS后台关闭：unfas   "
echo "停止VPN vpn stop        数据库开启：onsql    "
echo "开任意端口 port         数据库关闭：unsql    "
echo "---------------------------------------------"
echo "数据库60分钟自动备份，备份目录在/root/backup/"
echo "数据库手动备份命令：backup "
echo "APP下载地址: http://"$IP":"$lyApacheport"/fasapp_by_ly.apk"
echo "FAS破解作者: 凌一    QQ："$qqhao"         "
echo "烟雨如花交流群：259282245    欢迎你的加入！  "
echo "---------------------------------------------"
echo "---------------------------------------------"
exit;0
}
function infoapp() {
	clear
	echo
	read -p "请设置APP名称(默认：流量卫士): " llwsname
	if [ -z "$llwsname" ];then
	llwsname=流量卫士
	fi
	echo -e "已设置APP名称为:\033[32m "$llwsname"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://): " llwsIP
	if [ -z "$llwsIP" ];then
	llwsIP=`curl -s http://members.3322.org/dyndns/getip`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$llwsIP"\033[0m"
	
	echo
	read -p "请设置APP端口（默认：1024）: " lyApacheport
	if [ -z "$lyApacheport" ];then
	lyApacheport=1024
	fi
	echo -e "已设置APP端口为:\033[32m "$lyApacheport"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.dingd.vpn）: " llwsbaoming
	if [ -z "$llwsbaoming" ];then
	llwsbaoming=net.dingd.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$llwsbaoming"\033[0m"
	echo
	sleep 2
	echo "请稍等...."
	echo 
	sleep 3
	downloadhostxuanzhe
	sleep 2
	clear 
	sleep 2 
	echo -e "\033[1;32m制作开始...\033[0m"
	sleep 5 
}
function fashoutaijiance() {
	if [ $lyApacheport == 80 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为80，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 22 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为22，与SSH登录端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 21 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为21，与SFTP登录端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 25 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为25，与邮件发送端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 8080 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为8080，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 1194 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为1194，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 28080 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为28080，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 65080 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为65080，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 136 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为136，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 137 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为137，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 138 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为138，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 139 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为139，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 53 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为53，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 68 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为68与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 1195 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为1195，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 1196 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为1196，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 1197 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为1197，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 8081 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为8081，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 443 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为443，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 440 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为440，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 5353 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为5353，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 3389 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为3389，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 7505 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为7505，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 7506 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为7506，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 7507 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为7507，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 7508 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为7508，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 7509 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为7509，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 7510 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为7510，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 666 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为666，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 22223 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为22223，与OpenVPN免流端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $lyApacheport == 3306 ];then
	lyApacheport=1024
	echo -e "系统检测到您输入的Apache端口为3306，与MySQL负载端口冲突，系统已默认修改您的Apache端口为: \033[32m"$lyApacheport"\033[0m";
	echo
	sleep 3
	else
	echo "" >/dev/null 2>&1
	fi
	
}
function infofas() {
	clear
	echo
	echo -e "\033[1;42;37m尊敬的用户您好，搭建FAS系统之前请您先自定义以下信息，如不会填写请直接回车默认即可！\033[0m"
	echo
	sleep 1
	read -p "请设置后台账号(默认admin): " lyadminuser
	if [ -z "$lyadminuser" ];then
	lyadminuser=admin
	fi
	echo -e "已设置后台账号为:\033[32m "$lyadminuser"\033[0m"
	
	echo
	read -p "请设置后台密码(默认随机): " lyadminpass
	if [ -z "$lyadminpass" ];then
	lyadminpass=`date +%s%N | md5sum | head -c 20 ; echo`;
	fi
	echo -e "已设置后台密码为:\033[32m "$lyadminpass"\033[0m"
	
	echo
	read -p "请设置本地二级密码(默认随机): " lyadminbendipass
	if [ -z "$lyadminbendipass" ];then
	lyadminbendipass=$RANDOM$RANDOM
	fi
	echo -e "已设置本地二级密码为:\033[32m "$lyadminbendipass"\033[0m"
	
	echo
	read -p "请设置Apache端口(默认1024,禁用80): " lyApacheport
	if [ -z "$lyApacheport" ];then
	lyApacheport=1024
	fi
	echo -e "已设置Apache端口为:\033[32m http://"$IP":"$lyApacheport"\033[0m"
	
	echo
	read -p "请设置MySQL密码(默认随机): " lysqlpass
	if [ -z "$lysqlpass" ];then
	lysqlpass=`date +%s%N | md5sum | head -c 20 ; echo`;
	fi
	echo -e "已设置MySQL密码为:\033[32m "$lysqlpass"\033[0m"
	
	echo
	read -p "请设置APP名称(默认：流量卫士): " llwsname
	if [ -z "$llwsname" ];then
	llwsname=流量卫士
	fi
	echo -e "已设置APP名称密码为:\033[32m "$llwsname"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://): " llwsIP
	if [ -z "$llwsIP" ];then
	llwsIP=`curl -s http://members.3322.org/dyndns/getip`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$llwsIP"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.dingd.vpn）: " llwsbaoming
	if [ -z "$llwsbaoming" ];then
	llwsbaoming=net.dingd.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$llwsbaoming"\033[0m"
	sleep 1
	echo
	echo "请稍等..."
	sleep 2
	fashoutaijiance
	sleep 2
	downloadhostxuanzhe
	sleep 1
	echo
	echo -e "\033[1;5;31m所有信息已收集完成！即将为您安装FAS系统！\033[0m"
	sleep 3
	clear 
	sleep 1
	echo -e "\033[1;32m安装开始...\033[0m"
	sleep 5 
}
function infodongyun() {
	clear
	echo
	read -p "请输入您的Apache端口(默认1024,禁用80): " Apacheport
	if [ -z "$Apacheport" ];then
	Apacheport=1024
	fi
	echo -e "您已输入的Apache端口为:\033[32m "$Apacheport"\033[0m"
	sleep 2
	clear
	sleep 1
	printf "\n[\033[34m 1/1 \033[0m]   正在重置防火墙并关闭SELinux....\n";
	sleep 5
}
function fuzaiji() {
	sleep 1
	echo "请稍等，正在为您关闭负载机扫描..."
	sleep 3
	if [ ! -f /bin/jk.sh ]; then
	echo
	echo "警告！负载机扫描关闭失败！请确认您是否已经关闭过或还未搭建筑梦FAS系统！"
	exit;0
	fi
	rm -rf /bin/jk.sh
    vpn restart
	echo "负载机扫描关闭成功！感谢您的使用，再见！"
}
function mysqlstop() {
	sleep 1
	echo "请稍等，正在为您关闭负载机数据库服务..."
	sleep 3
	service mariadb stop >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "MariaDB关闭成功！感谢您的使用，再见！" >/dev/null 2>&1
	else
	echo "警告！MariaDB关闭失败！请手动关闭MariaDB查看失败原因！脚本停止！"
	exit 0
	fi
	systemctl disable mariadb.service >/dev/null 2>&1
	echo
	echo "MariaDB关闭成功！感谢您的使用，再见！"
}
function downloadhostxuanzhe() {
echo
echo -e "************************************************"
echo -e "             请选择FAS资源下载地址              "
echo -e "************************************************"
echo -e "请选择："
echo
echo -e "1、一号下载源（适用于中国大陆服务器）"
echo
echo -e "2、二号下载源（适用于国外海外服务器）"
echo
read -p " 请输入选项并回车: " a
echo
k=$a
if [[ $k == 1 ]];then
downloaddizhi="一号下载源（适用于中国大陆服务器）";
downloadhost="https://download.lyiqk.cn/ML/fas/";
fi
	
if [[ $k == 2 ]];then
echo  >/dev/null 2>&1
downloaddizhi="二号下载源（适用于国外海外服务器）";
downloadhost="https://download.lyiqk.cn/ML/fas/";
fi

echo

if [ -z "$downloadhost" ]; then 
echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
exit;0
fi

if [ -z "$downloaddizhi" ]; then 
echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
exit;0
fi

echo " 您选择的是：$downloaddizhi"

}
function menu() {
	clear
	echo
	echo -e "************************************************"
	echo -e "           欢迎使用FAS系统快速安装助手          "
	echo -e "        QQ：863963860   破解作者：凌一       "
	echo -e "************************************************"
	echo -e "请选择："
	echo
	echo -e "\033[31m 1、安装FAS系统 ("$banben"版)  ♪～(´ε｀　) \033[0m"
	echo ""
	echo -e "\033[31m 2、安装APP制作环境 (只需安装一次！后续制作无需安装！)   ♪～(´ε｀　) \033[0m"
	echo ""
	echo -e "\033[31m 3、制作APP (如您安装过APP环境则直接制作即可！)  ♪～(´ε｀　) \033[0m"
	echo
	echo -e "\033[31m 4、FAS系统负载(多台服务器集群负载)  ♪～(´ε｀　) \033[0m"
	echo
	echo -e "\033[31m 5、重置防火墙 (解决冬云等服务器安装没网)  ♪～(´ε｀　) \033[0m"
	echo
	echo -e "\033[31m 6、关闭数据库服务(负载副机关闭即可)  ♪～(´ε｀　) \033[0m"
	echo 
	echo -e "\033[31m 7、关闭负载机的扫描(关闭后可节省资源)  ♪～(´ε｀　) \033[0m"
	echo
	echo -e "\033[31m 8、添加TCP/UDP端口(你们都懂的)  ♪～(´ε｀　) \033[0m"
	echo
	echo 
	read -p " 请输入安装选项并回车: " a
	echo
	k=$a

	if [[ $k == 1 ]];then
	infofas
	clear
	printf "\n[\033[34m 1/7 \033[0m]   正在安装防火墙并关闭SELinux....\n";
	ly01
	printf "\n[\033[34m 2/7 \033[0m]   正在安装LAMP环境（耗时较长，耐心等待）....\n";
	ly02 >/dev/null 2>&1
	printf "\n[\033[34m 3/7 \033[0m]   正在部署流控程序....\n";
	ly03
	ly04
	ly05
	ly06
	printf "\n[\033[34m 4/7 \033[0m]   正在安装WEB面板....\n";
	web
	printf "\n[\033[34m 5/7 \033[0m]   正在依赖文件....\n";
	sbin
	printf "\n[\033[34m 6/7 \033[0m]   正在制作APP....\n";
	app
	printf "\n[\033[34m 7/7 \033[0m]   正在启动所有服务....\n";
	qidongya
	done1
	exit;0
	fi
	
	if [[ $k == 2 ]];then
	clear
	echo
	sleep 2 
	echo -e "\033[1;32m安装开始...\033[0m"
	clear
	sleep 2
	printf "\n[\033[34m 1/1 \033[0m]   正在安装APP所需环境（耗时较长，耐心等待）....\n";
	Installation
	echo "APP所需环境安装已完成，请执行脚本输入3制作您的APP吧！"
	exit;0
	fi
	
	if [[ $k == 3 ]];then
	infoapp
	clear
	printf "\n[\033[34m 1/1 \033[0m]   正在制作Fas - APP....\n";
	app1
	echo
	echo "筑梦FAS-APP制作完成，请前往/root 目录获取 fasapp_by_ly.apk 文件！"
	exit;0
	fi
	
	if [[ $k == 4 ]];then
	menufuzai
	exit;0
	fi
	
	if [[ $k == 5 ]];then
	infodongyun
	fhqcz
	exit;0
	fi
	
	if [[ $k == 6 ]];then
	mysqlstop
	exit;0
	fi
	
	if [[ $k == 7 ]];then
	fuzaiji
	exit;0
	fi
	
	if [[ $k == 8 ]];then
	port123
	exit;0
	fi
	
	if [[ $k == 9 ]];then
	echo "感谢您的使用，再见！"
	exit;0
	fi
	
	echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
	exit;0
}
function ipget() {
clear
sleep 2
echo
echo "请选择IP源获取方式（自动获取失败的，请选择手动输入！）"
echo
echo "1、自动获取IP（默认获取方式，系统推荐！）"
echo "2、手动输入IP（仅在自动获取IP失败或异常时使用！）"
echo
read -p "请输入: " a
echo
k=$a

if [[ $k == 1 ]];then
sleep 1
echo "请稍等..."
sleep 2
IP=`curl -s http://members.3322.org/dyndns/getip`;
localserver=`curl -s ip.cn`;
dizhi=`echo $localserver|awk '{print $3}'`
fwq=`echo $localserver|awk '{print $4}'`;
clear
sleep 1
echo
echo -e "系统检测到的IP为：\033[34m"$IP" "$dizhi""$fwq"\033[0m"
echo -e "如不正确请立即停止安装选择手动输入IP搭建，否则回车继续。"
read
sleep 1
echo "请稍等..."
sleep 3
menu
fi

if [[ $k == 2 ]];then
sleep 1
read -p "请输入您的IP/动态域名: " IP
if [ -z "$IP" ];then
IP=
fi
echo "请稍等..."
sleep 2
clear
sleep 1
echo
echo "系统检测到您输入的IP/动态域名为："$IP" 如不正确请立即停止安装，否则回车继续。"
read
sleep 1
echo "请稍等..."
sleep 3
menu
fi

echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
exit;0
}
function logo() {
clear
echo "请问破解作者帅不帅？"
echo " 1. 帅"
echo " 2. 非常帅"
echo
read -p " 请选择: " a
echo
k=$a

if [[ $k == 1 ]];then
clear
sleep 2
echo -e "\033[34m----------------------------------------------------------------------------\033[0m"
echo -e "\033[36m                         欢迎使用FAS网络用户管理系统                          \033[0m"
echo 
echo -e "\033[33m                        "$banben" ("$time123"更新 (No."$version"))            \033[0m"
echo -e "\033[32m        "
echo -e "\033[35m                   FAS流控系统破解脚本，破解作者："$Crackauthor"              \033[0m"
echo 
echo -e "\033[32m                   QQ："$qqhao"    凌一博客：https://lyiqk.cn         \033[0m "
echo
echo -e "\033[34m----------------------------------------------------------------------------\033[0m"
echo
echo -e "\033[34m------------------------------同意 请回车继续-------------------------------\033[0m"
read
ipget
fi

if [[ $k == 2 ]];then
clear
sleep 2
echo -e "\033[34m----------------------------------------------------------------------------\033[0m"
echo -e "\033[36m                         欢迎使用FAS网络用户管理系统                          \033[0m"
echo 
echo -e "\033[33m                        "$banben" ("$time123"更新 (No."$version"))            \033[0m"
echo -e "\033[32m        "
echo -e "\033[35m                   FAS流控系统破解脚本，破解作者："$Crackauthor"              \033[0m"
echo 
echo -e "\033[32m                   QQ："$qqhao"    凌一博客：https://lyiqk.cn         \033[0m "
echo
echo -e "\033[34m----------------------------------------------------------------------------\033[0m"
echo
echo -e "\033[34m------------------------------同意 请回车继续-------------------------------\033[0m"
read
ipget
fi
echo
sleep 2
echo -e "\033[31m 说我不帅的你就别想搭建了  哼！ ヾ(｡｀Д´｡)ﾉ彡  \033[0m "
echo
reboot
exit;0
}
function safe() {
if [ ! -e "/dev/net/tun" ]; then
    echo
    echo -e "\033[1;32m安装出错\033[0m \033[5;31m[原因：系统存在异常！]\033[0m 
	\033[1;32m错误码：\033[31mVFVOL1RBUOiZmuaLn+e9keWNoeS4jeWtmOWcqA== \033[0m\033[0m"
	exit 0;
fi
if [ ! -f /bin/mv ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：bXbkuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ ! -f /bin/cp ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：Y3DkuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ ! -f /bin/rm ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：cm3kuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ ! -f /bin/ps ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：cHPkuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ -f /etc/os-release ];then
OS_VERSION=`cat /etc/os-release |awk -F'[="]+' '/^VERSION_ID=/ {print $2}'`
if [ $OS_VERSION != "7" ];then
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS "$OS_VERSION" ，请更换系统为 CentOS 7.0 - 7.4 后重试！"
exit 0;
fi
elif [ -f /etc/redhat-release ];then
OS_VERSION=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`
if [ $OS_VERSION != "7" ];then
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS "$OS_VERSION" ，请更换系统为 CentOS 7.0 - 7.4后重试！"
exit 0;
fi
else
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS 未知 ，请更换系统为 CentOS 7.0 - 7.4 后重试！"
exit 0;
fi
}
function main() {
rm -rf $0 >/dev/null 2>&1
clear 
echo
echo "正在为脚本运行做准备."
sleep 5 
echo
echo "正在检查安装环境(预计三分钟内完成)...."
safe
#安装wget curl等等  修复vr服务器没selinux问题
yum -y install curl wget docker openssl net-tools procps-ng >/dev/null 2>&1
banben="V3.0";
time123="2019.08.11";
version="20190811修复版";
qqhao="863963860";
Crackauthor="凌一";
logo
}
main
exit;0