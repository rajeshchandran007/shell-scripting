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