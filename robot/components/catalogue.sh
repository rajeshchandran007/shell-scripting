#!/bin/bash

echo "I am the frontend component."

COMPONENT=catalogue
APPUSER=roboshop

source components/common.sh

echo -n "Installing nodejs:"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
yum install nodejs -y &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "Adding User:"
    useradd $APPUSER &>> $LOGFILE
    stat $?
fi


echo -n "Downloading project component $COMPONENT:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "Moving the component $COMPONENT to $APPUSER home directory"
cd /home/roboshop
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Performing cleanup"
rm -rf $COMPONENT
mv $COMPONENT-main $COMPONENT
stat $?

echo -n "Installing node js component"
cd /home/$APPUSER/$COMPONENT
npm install &>> $LOGFILE
stat $?

echo -n "Changing permission to $APPUSER"
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

