#!/bin/bash
set -e

echo "I am the mongodb component."

COMPONENT=mongodb

source components/common.sh

echo -n "Configuring the project's mongodb repo:"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo
stat $?

echo -n "Installing $COMPONENT"
yum install -y $COMPONENT-org &>> $LOGFILE
stat $?

echo -n "Updating $COMPONENT config file for 0.0.0.0"
sudo sed -i -e 's/127.0.0.1/0.0.0.0/' mongodb.conf
stat $?

echo -n "Restarting $COMPONENT"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?

echo -n "Download the schema for $COMPONENT"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "Unzip $COMPONENT.zip"
cd /tmp
unzip mongodb.zip &>> $LOGFILE
stat $?

echo -n "Inject the schema for tables catalogue and users in $COMPONENT"
cd mongodb-main
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat $?


