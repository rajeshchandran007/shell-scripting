#!/bin/bash
set -e

echo "I am the frontend component."

USERID=$(id -u)
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log

if  [ $USERID -ne 0 ] ; then
    echo -e "\e[31m Please execute as a root user\e[0m"
    exit 1
fi

stat() {

    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m Success\e[0m"
    else
        echo -e "\e[31m Fail\e[0m"
    fi
}

echo -n "Installing nginx:"
yum install nginx -y &>> $LOGFILE

stat $?

echo -n "Downloading project components:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"

stat $?

echo -n "Performing cleanup:"
cd /usr/share/nginx/html
rm -rf * &>> $LOGFILE

stat $?

echo -n "Unzipping the $COMPONENT:"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md &>> $LOGFILE

stat $?

echo -n "Placing the config file"
mv localhost.conf /etc/nginx/default.d/roboshop.conf

stat $?

echo -n "restarting nginx:"
systemctl enable nginx &>> $LOGFILE
systemctl start nginx &>> $LOGFILE

stat $?
