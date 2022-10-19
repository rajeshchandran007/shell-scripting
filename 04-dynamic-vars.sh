#!/bin/bash 

TODAY_DATE="$(date +%F)"
NO_OF_USERS="$(who | wc -l)"
A=100
X = "${a}"

echo "Good Morning, Todays date is ${TODAY_DATE}"
echo "Number of sessions opened are : ${NO_OF_USERS}"
echo "Value of X : ${X}"