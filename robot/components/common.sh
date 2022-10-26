USERID=$(id -u)
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

NODEJS() {

    echo -n "Installing nodejs:"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
    yum install nodejs -y &>> $LOGFILE
    stat $?

    CREATE_USER

    DOWNLOAD_AND_EXTRACT

    NPM_INSTALL

    CONFIGURE_SERVICE
}

CREATE_USER() {
    id $APPUSER &>> $LOGFILE
    if [ $? -ne 0 ] ; then
        echo -n "Adding User:"
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi
} 

DOWNLOAD_AND_EXTRACT() {
    echo -n "Downloading project component $COMPONENT:"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $?

    echo -n "Moving the component $COMPONENT to $APPUSER home directory"
    cd /home/roboshop
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
    stat $?

    echo -n "Performing cleanup"
    rm -rf $COMPONENT
    mv $COMPONENT-main $COMPONENT
    stat $?

    echo -n "Changing permission to $APPUSER"
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT && chmod -R 775 /home/$APPUSER/$COMPONENT &>> $LOGFILE
    stat $?
}

NPM_INSTALL() {
    echo -n "Installing node js dependencies"
    cd /home/$APPUSER/$COMPONENT
    npm install &>> $LOGFILE
    stat $?    
}

CONFIGURE_SERVICE() {
    echo -n "Configuring systemd file"
    sed -i -e 's/MONGO_DNSNAME/172.31.88.86/' /home/$APPUSER/$COMPONENT/systemd.service &>> $LOGFILE
    stat $?

    echo -n "Moving systemd file to /etc folder"
    mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>> $LOGFILE
    stat $?

    echo -n "Starting the $COMPONENT service"
    systemctl daemon-reload &>> $LOGFILE
    systemctl start $COMPONENT &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl status $COMPONENT -l &>> $LOGFILE
    stat $?
}