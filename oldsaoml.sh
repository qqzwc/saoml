#!/bin/bash
	PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
	export PATH
    rm -rf /usr/share/kernel >/dev/null 2>&1
	rm -rf /bin/gcore 
	rm -rf /bin/gdb 
	rm -rf /bin/heyixiao
	
	#更新
	function gengxin() {
	echo
	echo ""$banben" 版本开始更新很快几秒钟" 
	echo
	rm -rf /etc/dnsmasq.conf && wget -q https://download.lyiqk.cn/ML/saoml/dnsmasq.conf -P /etc && chmod 0777 /etc/dnsmasq.conf
	vpn restart
	echo
	echo ""$banben" 版本更新完毕" 
}


	#负载
	function fhqcz() {
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
	echo "防火墙安装成功！" >/dev/null 2>&1
	else
	echo -e "\033[1;31m警告！防火墙启动失败！启动自修复模式！\033[0m"
	yum -y install iptables-services >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "自修复成功！" 
	else
	echo -e "\033[1;31m警告！自修复失败请联系管理员修复！脚本停止！\033[0m"
	exit
	fi
	fi
	iptables -A INPUT -s 127.0.0.1/32  -j ACCEPT
	iptables -A INPUT -d 127.0.0.1/32  -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport $httpdport -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 440 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 3389 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1024 -j ACCEPT
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







#安装程序第2步
function N01() {
setenforce 0 >/dev/null 2>&1
if [ ! -f /etc/selinux/config ]; then
	#echo "SELinux检测不到的，关闭不掉的，或关闭失败的"
	echo "警告！SELinux关闭失败，请自行检查SELinux关键模块是否存在！脚本停止！"
	exit
fi
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
rm -rf /etc/sysctl.conf
wget -q https://download.lyiqk.cn/ML/saoml/sysctl.conf -P /etc
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
#启动自修复
echo "警告！IPtables启动失败！启动自修复模式！"
#停止firewalld防火墙
systemctl stop firewalld >/dev/null 2>&1
systemctl mask firewalld >/dev/null 2>&1
#禁用firewalld防火墙
systemctl disable firewalld >/dev/null 2>&1
#尝试停止iptables防火墙
systemctl stop iptables.service >/dev/null 2>&1
#安装iptables防火墙
yum -y install iptables >/dev/null 2>&1
yum -y install iptables-services >/dev/null 2>&1
#启动iptables防火墙
systemctl start iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "自修复成功！" 
else
echo -e "警告！自修复失败请联系管理员修复！脚本停止！"
exit
fi
fi


iptables -F
service iptables save >/dev/null 2>&1
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "防火墙安装成功" >/dev/null 2>&1
else
echo -e "警告！防火墙启动失败！启动自修复模式！"
yum -y install iptables-services >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "自修复成功！" 
else
echo -e "警告！自修复失败请联系管理员修复！脚本停止！"
exit
fi
fi
iptables -A INPUT -s 127.0.0.1/32  -j ACCEPT
iptables -A INPUT -d 127.0.0.1/32  -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport $faspost -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 440 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3389 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1024 -j ACCEPT
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
iptables -A INPUT -p udp -m udp --dport 68 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 67 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -p udp --dport 67 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 68 -j REDIRECT --to-ports 53
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





#安装程序第3步
function N02() {

yum -y install epel-release

yum -y install telnet avahi openssl openssl-libs openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig gawk tar zip unzip net-tools psmisc gcc pkcs11-helper mariadb mariadb-server httpd libxml2 libxml2-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel dnsmasq jre-1.7.0-openjdk

rpm -Uvh https://download.lyiqk.cn/ML/saoml/webtatic-release.rpm >/dev/null 2>&1

yum install php70w php70w-fpm php70w-bcmath php70w-cli php70w-common php70w-dba php70w-devel php70w-embedded php70w-enchant php70w-gd php70w-imap php70w-ldap php70w-mbstring php70w-mcrypt php70w-mysqlnd php70w-odbc php70w-opcache php70w-pdo php70w-pdo_dblib php70w-pear.noarch php70w-pecl-apcu php70w-pecl-apcu-devel php70w-pecl-imagick php70w-pecl-imagick-devel php70w-pecl-mongodb php70w-pecl-redis php70w-pecl-xdebug php70w-pgsql php70w-xml php70w-xmlrpc php70w-intl php70w-mcrypt --nogpgcheck php-fedora-autoloader php-php-gettext php-tcpdf php-tcpdf-dejavu-sans-fonts php70w-tidy -y

rpm -Uvh https://download.lyiqk.cn/ML/saoml/liblz4-1.8.1.2-alt1.x86_64.rpm >/dev/null 2>&1

rpm -Uvh https://download.lyiqk.cn/ML/saoml/openvpn-2.4.6-1.el7.x86_64.rpm >/dev/null 2>&1

}



#安装程序第4步
function N03() {
systemctl start mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then 
echo "MariaDB安装成功！" >/dev/null 2>&1
else
echo -e "警告！MariaDB初始化失败！脚本修复程序启动"
echo
echo -e "请耐心等待"
echo
yum -y install mariadb >/dev/null 2>&1
yum -y install mariadb-server >/dev/null 2>&1
systemctl start mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "自修复成功！" 
else
echo -e "警告！自修复失败请联系管理员修复！脚本停止！"
exit;0
fi
fi
mysqladmin -u root password "$fassqlpass"
mysql -u root -p$fassqlpass -e "create database vpndata;"
systemctl restart mariadb.service >/dev/null 2>&1
systemctl restart mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
exit;0
fi
systemctl enable mariadb.service >/dev/null 2>&1
systemctl enable mariadb.service >/dev/null 2>&1
}



#安装程序第5步
function N04() {
sed -i "s/#ServerName www.example.com:80/ServerName localhost:$faspost/g" /etc/httpd/conf/httpd.conf
sed -i "s/Listen 80/Listen $faspost/g" /etc/httpd/conf/httpd.conf
setenforce 0 >/dev/null 2>&1
systemctl start httpd.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Apache启动失败！请手动启动Apache查看失败原因！脚本停止！"
exit;0
fi
systemctl enable httpd.service >/dev/null 2>&1
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




#安装程序第6步
function N05() {
if [ ! -d /etc/openvpn ]; then
	echo "警告！OpenVPN安装失败，请自行检查rpm包下载源是否可用！脚本停止！"
	exit;0
fi
cd /etc/openvpn && rm -rf /etc/openvpn/*
wget -q https://download.lyiqk.cn/ML/saoml/openvpn.zip
if [ ! -f /etc/openvpn/openvpn.zip ]; then
	echo "警告！OpenVPN配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o openvpn.zip >/dev/null 2>&1
rm -rf openvpn.zip && chmod 0777 -R /etc/openvpn
sed -i "s/newpass/"$fassqlpass"/g" /etc/openvpn/auth_config.conf
sed -i "s/服务器IP/"$IP"/g" /etc/openvpn/auth_config.conf
systemctl enable openvpn@server1194.service >/dev/null 2>&1
systemctl enable openvpn@server1195.service >/dev/null 2>&1
systemctl enable openvpn@server1196.service >/dev/null 2>&1
systemctl enable openvpn@server1197.service >/dev/null 2>&1
systemctl enable openvpn@server-udp.service >/dev/null 2>&1
}




#安装程序第7步
function N06() {
if [ ! -f /etc/dnsmasq.conf ]; then
	echo "警告！dnsmasq安装失败，请自行检查dnsmasq是否安装正确！脚本停止！"
	exit;0
fi
rm -rf /etc/dnsmasq.conf && wget -q https://download.lyiqk.cn/ML/saoml/dnsmasq.conf -P /etc && chmod 0777 /etc/dnsmasq.conf
if [ ! -f /etc/dnsmasq.conf ]; then
	echo "警告！dnsmasq配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
systemctl enable dnsmasq.service >/dev/null 2>&1
systemctl start dnsmasq.service >/dev/null 2>&1
}




#安装程序第8步
function web() {
rm -rf /var/www/* && cd /var/www && wget -q https://download.lyiqk.cn/ML/saoml/szmlvpn_web.zip >/dev/null 2>&1
if [ ! -f /var/www/szmlvpn_web.zip ]; then
	echo "警告！SaoML系统-WEB配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o szmlvpn_web.zip >/dev/null 2>&1 && rm -rf szmlvpn_web.zip && chmod 0777 -R /var/www/html
sed -i "s/fasadmin/"$fasadminname"/g" /var/www/vpndata.sql
sed -i "s/faspass/"$fasadminpasswd"/g" /var/www/vpndata.sql
sed -i "s/服务器IP/"$IP"/g" /var/www/vpndata.sql
mysql -uroot -p$fassqlpass vpndata < /var/www/vpndata.sql
rm -rf /var/www/vpndata.sql
mv /var/www/html/fassql /var/www/html/$fassqlip
sed -i "s/newpass/"$fassqlpass"/g" /var/www/html/config.php
sed -i "s/SaoML加速器/"$mcc"/g" /var/www/html/web/index.html
sed -i "s/1277345571/"$mcqq"/g" /var/www/html/web/index.html
echo "$fasaqm">>/var/www/auth_key.access
chmod 777 /var/www/auth_key.access
}




#安装程序第9步
function sbin() {
mkdir /etc/rate.d/ && chmod -R 0777 /etc/rate.d/
cd /root&&wget -q https://download.lyiqk.cn/ML/saoml/res.zip
if [ ! -f /root/res.zip ]; then
	echo "警告！SaoML流控-res配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o res.zip >/dev/null 2>&1 && chmod -R 0777 /root && rm -rf /root/res.zip
mv /root/res/fas.service /lib/systemd/system/fas.service && chmod -R 0777 /lib/systemd/system/fas.service && systemctl enable fas.service >/dev/null 2>&1
cd /bin && wget -q https://download.lyiqk.cn/ML/saoml/bin.zip
if [ ! -f /bin/bin.zip ]; then
	echo "警告！SaoML流控命令指示符配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o bin.zip >/dev/null 2>&1 && rm -rf /bin/bin.zip && chmod -R 0777 /bin
}




#安装程序第11步
function qidongya() {
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
echo "警告！SaoML流控服务启动失败！请手动启动SaoML流控服务查看失败原因！脚本停止！"
exit;0
fi
dhclient >/dev/null 2>&1
vpn restart >/dev/null 2>&1
}

#安装程序第10步
function app() {
yum install jre-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
rm -rf /APP
mkdir /APP 
cd /APP
wget -q https://download.lyiqk.cn/ML/saoml/saoml.apk >/dev/null 2>&1
wget -q https://download.lyiqk.cn/ML/saoml/apktool.jar >/dev/null 2>&1
java -jar apktool.jar d saoml.apk >/dev/null 2>&1
rm -rf saoml.apk >/dev/null 2>&1
sed -i 's/IP:PORT/'${fasapkipname}:${faspost}'/g' `grep IP:PORT -rl /APP/saoml/smali/net/openvpn/openvpn/`
sed -i 's/云流量/'${fasapknames}'/g' "/APP/saoml/res/values/strings.xml"
sed -i 's/net.sbwml.openvpn/'${fasapkname}'/g' "/APP/saoml/AndroidManifest.xml" 
java -jar apktool.jar b saoml >/dev/null 2>&1
wget -q https://download.lyiqk.cn/ML/saoml/signer.zip >/dev/null 2>&1 && unzip -o signer.zip >/dev/null 2>&1
mv /APP/saoml/dist/saoml.apk /APP/saoml.apk >/dev/null 2>&1
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/saoml.apk /APP/saoml_sign.apk  >/dev/null 2>&1
rm -rf /var/www/html/saomlapp.apk >/dev/null 2>&1
cp -rf /APP/saoml_sign.apk /var/www/html/saomlapp.apk >/dev/null 2>&1
rm -rf /APP >/dev/null 2>&1
if [ ! -f /var/www/html/saomlapp.apk ]; then >/dev/null 2>&1
echo
echo "SaoML系统APP1制作失败！"
echo
echo ""
echo
echo ""
fi
}


#安装程序第10步
function app2() {
yum install libstdc++.so.6 -y >/dev/null 2>&1
yum install zlib.i686 -y >/dev/null 2>&1
yum install java-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
rm -rf /APP/ >/dev/null 2>&1
mkdir /APP >/dev/null 2>&1
cd /APP >/dev/null 2>&1
wget -q https://download.lyiqk.cn/ML/saoml/saoml2.apk >/dev/null 2>&1
wget -q https://download.lyiqk.cn/ML/saoml/apktool.jar >/dev/null 2>&1
java -jar apktool.jar d saoml2.apk >/dev/null 2>&1
rm -rf saoml2.apk >/dev/null 2>&1
sed -i 's/120.24.156.1:8888/'${fasapkipname}:${faspost}'/g' `grep 120.24.156.1:8888 -rl /APP/saoml2/smali/net/openvpn/openvpn/`
sed -i 's/云免流/'${fasapknames}'/g' "/APP/saoml2/res/values/strings.xml"
sed -i 's/vpn.binml.top/'${fasapkname2}'/g' "/APP/saoml2/AndroidManifest.xml" 
java -jar apktool.jar b saoml2 >/dev/null 2>&1
wget -q https://download.lyiqk.cn/ML/saoml/signer.zip >/dev/null 2>&1
unzip -o signer.zip >/dev/null 2>&1
mv /APP/saoml2/dist/saoml2.apk /APP/saoml2.apk >/dev/null 2>&1
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/saoml2.apk /APP/saoml2_sign.apk  >/dev/null 2>&1
rm -rf /var/www/html/saoml2.apk >/dev/null 2>&1
cp -rf /APP/saoml2_sign.apk /var/www/html/saoml2.apk >/dev/null 2>&1
rm -rf /APP >/dev/null 2>&1
if [ ! -f /var/www/html/saoml2.apk ]; then >/dev/null 2>&1
echo
echo "SaoML系统APP2制作失败！"
echo
echo ""
echo
echo ""
fi
}


function zhuji() {
	clear
	echo
	read -p "请输入本机数据库地址(localhost): " ffsqlip
	if [ -z "$ffsqlip" ];then
	ffsqlip=localhost
	fi
	
	echo
	read -p "请输入本机数据库端口(3306): " ffsqlport
	if [ -z "$ffsqlport" ];then
	ffsqlport=3306
	fi
	
	echo
	read -p "请输入本机数据库账号(root): " ffsqluser
	if [ -z "$ffsqluser" ];then
	ffsqluser=root
	fi
	
	echo
	read -p "请输入本机数据库密码: " fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=
	fi
	
	echo
	echo "正在为您的系统进行负载，请稍等......"
	sleep 2
	SQL_RESULT=`mysql -h${ffsqlip} -P${ffsqlport} -u${ffsqluser} -p${fassqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "数据库连接失败，请检查您的数据库密码后重试，脚本停止！";
	exit;
	fi
	
	iptables -A INPUT -p tcp -m tcp --dport $ffsqlport -j ACCEPT
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	
	mysql -h${ffsqlip} -P${ffsqlport} -u${ffsqluser} -p${fassqlpass} <<EOF
grant all privileges on *.* to '${ffsqluser}'@'%' identified by '${fassqlpass}' with grant option;
flush privileges;
EOF
	systemctl restart mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
	exit
	fi
	
	sleep 2
	echo
	echo "已成功为您的系统进行负载！您可以在任何搭载SaoML流控系统机器上对接至本服务器！"
	
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
	read -p "请输入本机IP: " ffbenjiip
	if [ -z "$ffbenjiip" ];then
	ffbenjiip=
	fi
	
	echo
	read -p "请输入主机IP: " ffsqlip
	if [ -z "$ffsqlip" ];then
	ffsqlip=
	fi
	
	echo
	read -p "请输入主机数据库端口: " ffsqlport
	if [ -z "$ffsqlport" ];then
	ffsqlport=
	fi
	
	echo
	read -p "请输入主机数据库账号: " ffsqluser
	if [ -z "$ffsqluser" ];then
	ffsqluser=
	fi
	
	echo
	read -p "请输入主机数据库密码: " fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=
	fi
	
	echo
	echo "正在为您的系统进行负载，请稍等......"
	sleep 2
	SQL_RESULT=`mysql -h${ffsqlip} -P${ffsqlport} -u${ffsqluser} -p${fassqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "连接至主机数据库失败，请检查您的主机数据库密码后重试，脚本停止！";
	exit;
	fi

	rm -rf /etc/openvpn/auth_config.conf
	echo '#!/bin/bash
mysql_host='$ffsqlip'
mysql_user='$ffsqluser'
mysql_pass='$fassqlpass'
mysql_port='$ffsqlport'
mysql_data=vpndata
address='$ffbenjiip'
unset_time=600
del="/root/res/del"

status_file_1="/var/www/html/openvpn_api/online_1194.txt 7075 1194 tcp-server"
status_file_2="/var/www/html/openvpn_api/online_1195.txt 7076 1195 tcp-server"
status_file_3="/var/www/html/openvpn_api/online_1196.txt 7077 1196 tcp-server"
status_file_4="/var/www/html/openvpn_api/online_1197.txt 7078 1197 tcp-server"
status_file_5="/var/www/html/openvpn_api/user-status-udp.txt 7079 53 udp"
sleep=3'>/etc/openvpn/auth_config.conf && chmod -R 0777 /etc/openvpn/auth_config.conf
rm -rf /var/www/html/config.php
echo '<?php
/* 请勿修改 */
define("_host_","'$ffsqlip'");
define("_user_","'$ffsqluser'");
define("_pass_","'$fassqlpass'");
define("_port_","'$ffsqlport'");
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
	
	sleep 2
	echo
	echo "已成功为您的系统进行负载！主机IP为："$ffsqlip"！"
	echo 
	echo "副机系统请前往shell控制台输入 unfas、unsql 关闭后台登录权限，以防被不法份子入侵系统！"
	echo
	echo "请您及时前往主机FAS后台管理添加本机，本机IP: "$ffbenjiip""
}
function menufuzai() {
	clear
	echo
	echo -e "================================================"
	echo -e "           欢迎使用SaoML系统负载管理          "
	echo -e "================================================"
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
	zhuji
	exit;0
	fi
	
	if [[ $k == 2 ]];then
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



#安装程序第12步
function done1() {
unsql >/dev/null 2>&1
password2=$(cat /var/www/auth_key.access);

clear
echo "---------------------------------------------"
echo "---------------------------------------------"
echo "恭喜，您已经成功安装SaoML流控™"$banben"管理系统。"
echo "控制台: http://"$IP":"$faspost"/admin/"
echo "账号: "$fasadminname" 密码: "$fasadminpasswd""
echo "控制台安全码: "$password2""
echo "内置数据库管理: http://"$IP":"$faspost"/"$fassqlip"/"
echo "---------------------------------------------"
echo "数据库账户: root   密码: "$fassqlpass"      "
echo "代理控制台: http://"$IP":"$faspost"/daili"
echo "---------------------------------------------"
echo "常用指令: "
echo "重启VPN vpn restart     流控后台开启：onfas   "
echo "启动VPN vpn start       流控后台关闭：unfas   "
echo "停止VPN vpn stop        数据库开启：onsql    "
echo "开任意端口 port         数据库关闭：unsql    "
echo "---------------------------------------------"
echo "数据库60分钟自动备份，备份目录在/root/backup/"
echo "数据库手动备份命令：backup "
echo "---------------------------------------------"
echo "用户页面: http://"$IP":"$faspost""
echo "APP1下载地址: http://"$IP":"$faspost"/saomlapp.apk"
echo "APP2下载地址: http://"$IP":"$faspost"/saoml2.apk"
echo "---------------------------------------------"
echo "APP2下载以后如果要修改什么请看后台使用文档"
echo "---------------------------------------------"
echo "欢迎加入SaoML新交流群727186773"
echo "---------------------------------------------"
echo "---------------------------------------------"
echo '#SaoML官网：ml.saoml.xyz' >> /var/www/html/daili/daili.txt && chmod 777 /var/www/html/daili/daili.txt
echo '#SaoML官网：ml.saoml.xyz' >> /var/www/html/app_api/denglu.txt && chmod 777 /var/www/html/app_api/denglu.txt
echo '#SaoML官网：ml.saoml.xyz' >> /var/www/html/app_api/jiemian.txt && chmod 777 /var/www/html/app_api/jiemian.txt
echo '#SaoML官网：ml.saoml.xyz' >> /etc/saoml_hosts && chmod 777 /etc/saoml_hosts
echo '#SaoML官网：ml.saoml.xyz' >> /etc/cjgf && chmod 777 /etc/cjgf
echo '#SaoML官网：ml.saoml.xyz' >> /etc/cjgjf && chmod 777 /etc/cjgjf
echo '#SaoML官网：ml.saoml.xyz' >> /etc/qqfc && chmod 777 /etc/qqfc
echo '#SaoML官网：ml.saoml.xyz' >> /etc/cfm && chmod 777 /etc/cfm
echo '#SaoML官网：ml.saoml.xyz' >> /etc/wzry && chmod 777 /etc/wzry
echo "当前版本：$banben" >> /var/www/html/banben.txt && chmod 777 /var/www/html/banben.txt
echo '#!/bin/bash' >> /usr/bin/jwboot && chmod 777 /usr/bin/jwboot
echo 'iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080' >> /usr/bin/jwboot && chmod 777 /usr/bin/jwboot
echo 'iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8080' >> /usr/bin/jwboot && chmod 777 /usr/bin/jwboot
echo
cd /root
read -p "恭喜你完成安装SaoML流控系统，回车完成安装！"
vpn restart 
}











#app设置信息
function infoapp() {
	clear
	echo
	read -p "请设置APP名称(默认：骚猪卫士): " fasapknames
	if [ -z "$fasapknames" ];then
	fasapknames=骚猪卫士
	fi
	echo -e "已设置APP名称为:\033[32m "$fasapknames"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://): " fasapkipname
	if [ -z "$fasapkipname" ];then
	fasapkipname=`curl -s http://members.3322.org/dyndns/getip`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$fasapkipname"\033[0m"
	
	echo
	read -p "请设置APP端口（默认：1024）: " faspost
	if [ -z "$faspost" ];then
	faspost=1024
	fi
	echo -e "已设置APP端口为:\033[32m "$faspost"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.saoml.vpn）: " fasapkname
	if [ -z "$fasapkname" ];then
	fasapkname=net.saoml.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname"\033[0m"
	
	echo
	read -p "请设置APP2包名（默认：net.saoml2.vpn）: " fasapkname2
	if [ -z "$fasapkname2" ];then
	fasapkname2=net.saoml2.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname2"\033[0m"
	
	sleep 2
	clear 
	sleep 2 
	echo -e "\033[1;32m制作开始...\033[0m"
	sleep 2 
}
function fashoutaijiance() {
	if [ $fassqlip == phpMyAdmin ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为phpMyAdmin，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == llws ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为llws，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == phpmyadmin ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为phpmyadmin，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == sql ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为sql，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == admin ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为admin，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
}



#安装程序第1步
function infofas() {
	clear
	echo -e "\033[1;42;37m尊敬的用户您好，搭建SaoML流控™系统之前请您先自定义以下信息，如不会填写请直接回车默认即可！\033[0m"
	echo
	sleep 1
	read -p "请设置流控后台账号(默认admin): " fasadminname
	if [ -z "$fasadminname" ];then
	fasadminname=admin
	fi
	echo -e "已设置流控后台账号为:\033[32m "$fasadminname"\033[0m"
	
	echo
	read -p "请设置流控后台密码(默认随机): " fasadminpasswd
	if [ -z "$fasadminpasswd" ];then
	fasadminpasswd=`date +%s%N | md5sum | head -c 20 ; echo`;
	fi
	echo -e "已设置流控后台密码为:\033[32m "$fasadminpasswd"\033[0m"
	
	echo
	read -p "请设置流控后台安全码(默认123): " fasaqm
	if [ -z "$fasaqm" ];then
	fasaqm=123
	fi
	echo -e "已设置流控后台安全码为:\033[32m "$fasaqm"\033[0m"
	
	echo
	read -p "请设置流控后台端口(默认1024,禁用80): " faspost
	if [ -z "$faspost" ];then
	faspost=1024
	fi
	echo -e "已设置流控后台地址端口为:\033[32m http://"$IP":"$faspost"\033[0m"
	
	echo
	read -p "请设置前端名称(默认SaoML加速器): " mcc
	if [ -z "$mcc" ];then
	mcc=SaoML加速器
	fi
	echo -e "已设置前端名称为:\033[32m"$mcc"\033[0m"
	
	echo
	read -p "请设置前端QQ(默认1277345571): " mcqq
	if [ -z "$mcqq" ];then
	mcqq=1277345571
	fi
	echo -e "已设置前端名称为:\033[32m"$mcqq"\033[0m"
	
	echo
	read -p "请设置数据库管理地址(默认随机,禁用phpMyAdmin): " fassqlip
	if [ -z "$fassqlip" ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	fi
	echo -e "已设置数据库地址为:\033[32m http://"$IP":"$faspost"/"$fassqlip"\033[0m"
	
	echo
	read -p "请设置数据库密码(默认随机): " fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=`date +%s%N | md5sum | head -c 20 ; echo`;
	fi
	echo -e "已设置数据库密码为:\033[32m "$fassqlpass"\033[0m"
	
	echo
	read -p "请设置APP名称(默认：骚猪加速器): " fasapknames
	if [ -z "$fasapknames" ];then
	fasapknames=骚猪加速器
	fi
	echo -e "已设置APP名称为:\033[32m "$fasapknames"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://，默认本机IP): " fasapkipname
	if [ -z "$fasapkipname" ];then
	fasapkipname=`curl -s http://members.3322.org/dyndns/getip`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$fasapkipname"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.saoml.vpn）: " fasapkname
	if [ -z "$fasapkname" ];then
	fasapkname=net.saoml.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.saoml2.vpn）: " fasapkname2
	if [ -z "$fasapkname2" ];then
	fasapkname2=net.saoml2.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname2"\033[0m"
	sleep 1
	echo
	echo "请稍等..."
	sleep 2
	echo
	fashoutaijiance
	echo -e "\033[1;5;31m所有信息已收集完成！即将为您安装SaoML流控™"$banben"管理系统！\033[0m"
	sleep 3
	clear 
	sleep 1
	echo -e "\033[1;32m安装开始...\033[0m"
	sleep 5 
}
function infodongyun() {
	clear
	echo
	read -p "请输入您的后台端口(默认1024): " httpdport
	if [ -z "$httpdport" ];then
	httpdport=1024
	fi
	echo -e "您已输入的后台端口为:\033[32m "$httpdport"\033[0m"
	sleep 2
	clear
	sleep 1
	printf "\n[\033[34m 1/1 \033[0m]   正在重置防火墙并关闭SELinux....\n";
	sleep 2
}
function fuzaiji() {
	sleep 1
	echo "请稍等，正在为您关闭负载机扫描..."
	sleep 2
	if [ ! -f /bin/jk.sh ]; then
	echo
	echo "警告！负载机扫描关闭失败！请确认您是否已经关闭过或还未搭建筑SaoML流控系统！"
	exit;0
	fi
	rm -rf /bin/jk.sh
    vpn restart
	echo "负载机扫描关闭成功！感谢您的使用，再见！"
}
function mysqlstop() {
	sleep 1
	echo "请稍等，正在为您关闭负载机数据库服务..."
	sleep 2
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
#选择主界面
function menu() {
	clear
	echo -e " 欢迎使用SaoML系统"
	echo
	if [ ! -f /var/www/html/banben.txt ]; then >/dev/null 2>&1
	echo -e " 警告！检测到你未安装系统或删除了检测文件，如果删除了文件建议更新一下SaoML系统"
	else
	var=$(cat /var/www/html/banben.txt) >/dev/null 2>&1
	echo -e "" $var""
	fi
	echo 
	echo -e "\033[31m 1、安装全新SaoML系统 \033[0m"
	echo 
	echo -e "\033[31m 2、修复SaoML系统后台（解决后台打开出现目录的问题） \033[0m"
	echo 
	echo -e "\033[31m 3、更新SaoML系统（最新版本"$banben"） \033[0m"
	echo 
	echo -e "\033[31m 4、制作系统APP       10、制作代理APP \033[0m"          
	echo
	echo -e "\033[31m 5、SaoML系统对接（服务器负载集群）\033[0m"
	echo
	echo -e "\033[31m 6、重置防火墙(解决部分高防服务器没网)\033[0m"
	echo
	echo -e "\033[31m 7、关闭数据库服务    8、关闭负载机的扫描\033[0m"
	echo
	echo -e "\033[31m 9、退出脚本 \033[0m"
	echo
	read -p " 请输入安装选项并回车: " a
	echo
	k=$a

	if [[ $k == 1 ]];then
	infofas
	clear
	echo -e "\033[31m给我TM的耐心等\033[0m"
	echo
	echo -e "\033[31m只要不报错就给我耐心等\033[0m"
	printf "\n[\033[34m 1/13 \033[0m]   正在安装第1步\n";
	N01
	printf "\n[\033[34m 2/13 \033[0m]   正在安装第2步\n";
	N02 >/dev/null 2>&1
	printf "\n[\033[34m 3/13 \033[0m]   正在安装第3步\n";
	N03
	printf "\n[\033[34m 4/13 \033[0m]   正在安装第4步\n";
	N04
	printf "\n[\033[34m 5/13 \033[0m]   正在安装第5步\n";
	N05
	printf "\n[\033[34m 6/13 \033[0m]   正在安装第6步\n";
	N06
	printf "\n[\033[34m 7/13 \033[0m]   正在安装第7步\n";
	web
	printf "\n[\033[34m 8/13 \033[0m]   正在安装第8步\n";
	sbin
	printf "\n[\033[34m 9/13 \033[0m]   正在制作 APP1\n";
	app
	printf "\n[\033[34m 10/13 \033[0m]  正在制作 APP2\n";
	app2
	printf "\n[\033[34m 11/13 \033[0m]  正在启动服务1\n";
	qidongya
	printf "\n[\033[34m 12/13 \033[0m]  正在启动服务2\n";
	
	printf "\n[\033[34m 13/13 \033[0m]  启动服务完 成\n";
	done1
	exit;0
	fi
	
	if [[ $k == 2 ]];then
	clear
	sleep 2
	echo && echo "请稍等."
	sleep 2
	cd /root 
	echo "正在修复中，请耐心等待！（预计10分钟内完成！）"
	sleep 5
	yum -y install epel-release
	rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
	yum -y install php70w php70w-bcmath php70w-cli php70w-common php70w-dba php70w-devel php70w-embedded php70w-enchant php70w-gd php70w-imap php70w-ldap php70w-mbstring php70w-mcrypt php70w-mysqlnd php70w-odbc php70w-opcache php70w-pdo php70w-pdo_dblib php70w-pear.noarch php70w-pecl-apcu php70w-pecl-apcu-devel php70w-pecl-imagick php70w-pecl-imagick-devel php70w-pecl-mongodb php70w-pecl-redis php70w-pecl-xdebug php70w-pgsql php70w-xml php70w-xmlrpc php70w-intl php70w-mcrypt --nogpgcheck php-fedora-autoloader php-php-gettext php-tcpdf php-tcpdf-dejavu-sans-fonts php70w-tidy --skip-broken
	systemctl restart httpd.service
	echo "修复已完成，请打开后台查看是否正常！如果无效请交流群反馈！"
	exit;0
	fi
	
		
	if [[ $k == 3 ]];then
	clear
	echo -e "\033[1;32m安装开始...\033[0m"
	sleep 2 
	gengxin
	exit;0
	fi
	
	if [[ $k == 4 ]];then
	#重新APP生成
	function daili1() {
	yum install jre-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
	rm -rf /APP >/dev/null 2>&1
	mkdir /APP >/dev/null 2>&1
	cd /APP >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/saoml.apk >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/apktool.jar >/dev/null 2>&1
	java -jar apktool.jar d saoml.apk >/dev/null 2>&1
	rm -rf saoml.apk >/dev/null 2>&1
	sed -i 's/IP:PORT/'${fasapkipname}:${faspost}'/g' `grep IP:PORT -rl /APP/saoml/smali/net/openvpn/openvpn/`
	sed -i 's/云流量/'${fasapknames}'/g' "/APP/saoml/res/values/strings.xml"
	sed -i 's/net.sbwml.openvpn/'${fasapkname}'/g' "/APP/saoml/AndroidManifest.xml"
	java -jar apktool.jar b saoml >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/signer.zip >/dev/null 2>&1 && unzip -o signer.zip >/dev/null 2>&1
	mv /APP/saoml/dist/saoml.apk /APP/saoml.apk >/dev/null 2>&1
	java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/saoml.apk /APP/saoml_sign.apk  >/dev/null 2>&1
	rm -rf /var/www/html/saomlapp.apk >/dev/null 2>&1
	cp -rf /APP/saoml_sign.apk /var/www/html/saomlapp.apk >/dev/null 2>&1
	rm -rf /APP >/dev/null 2>&1
	if [ ! -f /var/www/html/saomlapp.apk ]; then
	echo
	echo "SaoML系统APP制作失败！"
	echo
	echo ""
	echo
	echo ""
	fi
	}
	#重新APP生成
	function daili2() {
	yum install libstdc++.so.6 -y >/dev/null 2>&1
	yum install zlib.i686 -y >/dev/null 2>&1
	yum install java-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
	rm -rf /APP/ >/dev/null 2>&1
	mkdir /APP >/dev/null 2>&1
	cd /APP >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/saoml2.apk >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/apktool.jar >/dev/null 2>&1
	java -jar apktool.jar d saoml2.apk >/dev/null 2>&1
	rm -rf saoml2.apk >/dev/null 2>&1
	sed -i 's/120.24.156.1:8888/'${fasapkipname}:${faspost}'/g' `grep 120.24.156.1:8888 -rl /APP/saoml2/smali/net/openvpn/openvpn/`
	sed -i 's/云免流/'${fasapknames}'/g' "/APP/saoml2/res/values/strings.xml"
	sed -i 's/vpn.binml.top/'${fasapkname2}'/g' "/APP/saoml2/AndroidManifest.xml" 
	java -jar apktool.jar b saoml2 >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/signer.zip >/dev/null 2>&1
	unzip -o signer.zip >/dev/null 2>&1
	mv /APP/saoml2/dist/saoml2.apk /APP/saoml2.apk >/dev/null 2>&1
	java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/saoml2.apk /APP/saoml2_sign.apk  >/dev/null 2>&1
	rm -rf /var/www/html/saoml2.apk >/dev/null 2>&1
	cp -rf /APP/saoml2_sign.apk /var/www/html/saoml2.apk >/dev/null 2>&1
	rm -rf /APP >/dev/null 2>&1
	echo
	echo "saoml流控-APP制作完成，使用原下载连接下载即可！"
	if [ ! -f /var/www/html/saoml2.apk ]; then >/dev/null 2>&1
	echo
	echo "SaoML系统APP2制作失败！"
	echo
	echo ""
	echo
	echo ""
	fi
	}
	infoapp
	clear
	printf "\n[\033[34m 1/2 \033[0m]   正在制作saoml - APP1....\n";
	daili1
	printf "\n[\033[34m 2/2 \033[0m]   正在制作saoml - APP2....\n";
	daili2
	echo
	echo "APP下载地址: http://"$fasapkipname":"$faspost"/saomlapp.apk"
	echo
	echo "APP下载地址: http://"$fasapkipname":"$faspost"/saoml2.apk"
	echo
	exit;0
	fi
	
	if [[ $k == 5 ]];then
	menufuzai
	exit;0
	fi
	
	if [[ $k == 6 ]];then
	infodongyun
	fhqcz
	exit;0
	fi
	
	if [[ $k == 7 ]];then
	mysqlstop
	exit;0
	fi
	
	if [[ $k == 8 ]];then
	fuzaiji
	exit;0
	fi
	
	if [[ $k == 9 ]];then
	echo "感谢您的使用，再见！"
	exit;0
	fi
	
	if [[ $k == 10 ]];then
	clear
	echo
	read -p "请设置APP名称(默认：骚猪卫士): " fasapknames
	if [ -z "$fasapknames" ];then
	fasapknames=骚猪卫士
	fi
	echo -e "已设置APP名称为:\033[32m "$fasapknames"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://): " fasapkipname
	if [ -z "$fasapkipname" ];then
	fasapkipname=`curl -s http://members.3322.org/dyndns/getip`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$fasapkipname"\033[0m"
	
	echo
	read -p "请设置APP端口（默认：1024）: " faspost
	if [ -z "$faspost" ];then
	faspost=1024
	fi
	echo -e "已设置APP端口为:\033[32m "$faspost"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.saomldl.vpn）: " fasapkname
	if [ -z "$fasapkname" ];then
	fasapkname=net.saomldl.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname"\033[0m"
	
	echo
	read -p "请设置代理KEY（比如：_1）: " faskey
	if [ -z "$faskey" ];then
	faskey=_1
	fi
	echo -e "已设置APP包名为:\033[32m "$faskey"\033[0m"
	sleep 2
	clear 
	sleep 2 
	echo -e "\033[1;32m制作开始...\033[0m"
	sleep 2 
	yum install jre-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
	rm -rf /var/www/html/saomldaili.apk >/dev/null 2>&1
	rm -rf /APP >/dev/null 2>&1
	mkdir /APP >/dev/null 2>&1
	cd /APP >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/saoml.apk >/dev/null 2>&1
	wget -q https://download.lyiqk.cn/ML/saoml/apktool.jar >/dev/null 2>&1
	java -jar apktool.jar d saoml.apk
	rm -rf saoml.apk >/dev/null 2>&1
	sed -i 's/IP:PORT/'${fasapkipname}:${faspost}'/g' `grep IP:PORT -rl /APP/saoml/smali/net/openvpn/openvpn/`
	sed -i 's/DDWSKEY/'${faskey}'/g' `grep DDWSKEY -rl /APP/saoml/smali/net/openvpn/openvpn/`
	sed -i 's/云流量/'${fasapknames}'/g' "/APP/saoml/res/values/strings.xml"
	sed -i 's/net.sbwml.openvpn/'${fasapkname}'/g' "/APP/saoml/AndroidManifest.xml"
	java -jar apktool.jar b saoml
	wget -q https://download.lyiqk.cn/ML/saoml/signer.zip >/dev/null 2>&1 && unzip -o signer.zip >/dev/null 2>&1
	mv /APP/saoml/dist/saoml.apk /APP/saoml.apk >/dev/null 2>&1
	java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/saoml.apk /APP/saoml_sign.apk
	cp -rf /APP/saoml_sign.apk /var/www/html/saomldaili.apk >/dev/null 2>&1
	rm -rf /APP >/dev/null 2>&1
	clear
	echo "saoml流控-APP制作完成，使用原下载连接下载即可！"
	echo
	echo "代理APP下载地址: http://"$fasapkipname":"$faspost"/saomldaili.apk"
	echo
	if [ ! -f /var/www/html/saomldaili.apk ]; then
	echo
	echo "SaoML系统APP制作失败！"
	echo
	echo ""
	echo
	echo ""
	fi
	exit;0
	fi
	echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
	exit;0
}
function ipget() {
clear
sleep 2
localserver=`curl -s ip.cn`;
dizhi=`echo $localserver|awk '{print $3}'`
fwq=`echo $localserver|awk '{print $4}'`;
##错误执行yum install net-tools
wangka1=`ifconfig`;wangka2=`echo $wangka1|awk '{print $1}'`;wangka=${wangka2/:/};
echo "请选择IP源获取方式（自动获取失败的，请选择手动输入！）"
echo
echo "1、自动获取IP"
echo "2、手动输入IP"
echo
read -p "请输入: " a
echo
k=$a

if [[ $k == 1 ]];then
sleep 1
echo "请稍等..."
sleep 2
IP=`curl -s http://members.3322.org/dyndns/getip`;
clear
sleep 1
echo -e "系统检测到的IP为：\033[37m"$IP" ，网卡为："$wangka"\033[0m"
echo -e "如不正确请立即停止安装选择手动输入IP搭建，否则回车继续。"
read
sleep 1
echo "请稍等..."
sleep 2
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
echo "系统检测到您输入的IP/动态域名为："$IP"，如不正确请立即停止安装，回车继续："
read
sleep 1
echo "请稍等..."
sleep 2
menu
fi

echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
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
centos_v=`cat /etc/os-release |awk -F'[="]+' '/^VERSION_ID=/ {print $2}'`
if [ $centos_v != "7" ];then
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS "$centos_v" ，请更换系统为 CentOS 7.0 - 7.4 后重试！"
exit 0;
fi
elif [ -f /etc/redhat-release ];then
centos_v=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`
if [ $centos_v != "7" ];then
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS "$centos_v" ，请更换系统为 CentOS 7.0 - 7.4后重试！"
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
yum -y install wget;
clear 
echo "脚本开始运行"
sleep 2 
echo
echo "检查安装环境（建议使用Centos7.0x64---7.4x64搭建）"
safe
yum -y install curl wget openssl >/dev/null 2>&1
banben="v4.6";
host=https://download.lyiqk.cn/ML/saoml/
ipget
}
main
exit;0
