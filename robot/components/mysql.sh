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

echo "show databases;" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ $? -ne 0 ]
    echo -n "Changing the default password:"
    TEMP_PWD=$(grep 'temporary password' /var/log/mysqld.log | awk -F ' ' '{print $NF}')
    echo "ALTER USER 'root@localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p"${TEMP_PWD}" &>> $LOGFILE
    stat $?
fi

show plugins | mysql -uroot -pRoboShop@1 | grep validate_password &>> $LOGFILE
if [ $? -eq 0 ]
    echo -n "Uninstall the password validate plugin:"
    uninstall plugin validate_password; | mysql --connect-expired-password -uroot -pRoboShop@1 &>> $LOGFILE
    stat $?
fi

echo -n "Download the $COMPONENT Schema:"
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
cd /tmp
unzip -o $COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Inject the $COMPONENT Schema:"
cd $COMPONENT-main
mysql -u root -pRoboShop@1 < shipping.sql &>> $LOGFILE
stat $?

echo -e "\e[32m -----$COMPONENT installation completed-----\e[0m"

