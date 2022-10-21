#!/bin/bash
set -e

echo "I am the frontend component."

USERID=$(id -u)

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
yum install nginx -y &>> /tmp/frontend.log

stat $?

echo -n "Downloading project components:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

stat $?

echo -n "Performing cleanup:"
cd /usr/share/nginx/html
rm -rf * &>> /tmp/frontend.log
unzip /tmp/frontend.zip &>> /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md &>> /tmp/frontend.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf

stat $?

echo -n "restarting nginx:"
systemctl enable nginx &>> /tmp/frontend.log
systemctl start nginx &>> /tmp/frontend.log

stat $?
