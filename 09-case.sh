#!/bib/bash

# case $1 in

#     opt1)

#     opt2)

# esac

ACTION=$1
case $ACTION in

    start)
    echo "Start the script" 
    ;;
    
    stop)
    echo "Stop the script" 
    ;;
    *)
    echo "Give start or stop as the input"
    
esac

