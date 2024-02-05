#!/bin/bash

while true
do
        temp=$(vcgencmd measure_temp | grep  -o -E '[[:digit:]].*')
        printf "%s %s \n" "$(date) - " "$temp"
        sleep 1;
done
