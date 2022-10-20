#!/bin/bash

#Declaring a function

sample() {

    echo "This msg is from Sample Function"

}

sample

stat() {
    echo "Load avarage on the system is: $(uptime | awk -F : '{print $4}' | awk -F , '{print $1}')"
    echo "No of users signed in: $(who | wc -l)"
    echo "Function stat is completed"
    echo "...Calling sample function from here..."
    sample
}

stat