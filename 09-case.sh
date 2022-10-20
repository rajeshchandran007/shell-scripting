#!/bib/bash

# case $1 in

#     opt1)

#     opt2)

# esac

ACTION=$1
case $ACTION in

    start)
    echo "Start the script" 
    exit 0
    ;;
    
    stop)
    echo "Stop the script" 
    exit 1
    ;;
    *)
    echo -e "\e[31m Give start or stop as the input\e[0m"
    exit 2
    
esac

