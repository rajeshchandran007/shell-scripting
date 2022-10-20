#!/bin/bash

#Declaring a function

sample() {

    echo I am inside sample function

}

sample

stat() {
    echo "Load avarage on the system is: $(uptime | awk -F : '{print $4}' | awk -F , '{print $1}')"
    echo "No of users signed in: $(who | wc -l)"
}

stat