#!/bin/bash 

### Special Variables in Linux are : $0 to $n , $* , $@ , $# , $$ 

echo -e "\e[32m Name of the Script: \e[0m"$0   # Prints the script name that you're running
echo "First argument: "$1   # First argument from the command line
echo "Second argument: "$2   # Second argument from the command line

echo "All the arguments: "$*   # Gives you all the arguments used in the script
echo "All the arguments: "$@   # Gives you all the arguments used in the script
echo "No of arguments: "$#   # Gves you the number of arguments users
echo "Process ID: "$$   # Gives you the PID of the current process

# On command you can supply 9 variables 
# Ex  
#  sh abc.sh 10 20 30 40