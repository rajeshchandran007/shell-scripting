#!/bin/bash

echo "I am the mysql component."

COMPONENT=mysql
APPUSER=roboshop

source components/common.sh

echo -n "Configuring the $COMPONENT repo:"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT:"
yum install mysql-community-server -y &>> $LOGFILE
stat $?

echo -n "Start $COMPONENT service:"
systemctl enable mysqld && systemctl start mysqld
stat $?

echo -n "Changing the default password:"
grep 'temporary password' /var/log/mysqld.log | awk -F ' ' '{print $NF}'
stat $?

#( Copy that password )
# mysql_secure_installation
# mysql -uroot -pRoboShop@1
#> uninstall plugin validate_password;
# curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql

echo -e "\e[32m -----$COMPONENT installation completed-----\e[0m"

