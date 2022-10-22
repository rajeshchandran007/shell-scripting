#!/bin/bash

echo "I am the redis component."

COMPONENT=redis
APPUSER=roboshop

source components/common.sh

echo -n "Installing $COMPONENT:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
yum install redis-6.2.7 -y &>> $LOGFILE
stat $?

echo -n "Update config file for whitelisting:"
vim /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT.conf &>> $LOGFILE
stat $?

echo -n "Start $COMPONENET service:"
systemctl enable $COMPONENT &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
systemctl status $COMPONENT -l &>> $LOGFILE
stat $?




