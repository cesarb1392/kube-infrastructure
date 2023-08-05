#!/bin/bash

temp=$(vcgencmd measure_temp | grep  -o -E '[[:digit:]].*')
printf "%s %s" "$(date) - " "$temp"
