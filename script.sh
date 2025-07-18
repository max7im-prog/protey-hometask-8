#!/bin/bash

while [ 1 ]
do
    foundDirectory=false
    while [ $foundDirectory = false ]
    do
        heavyProcess=$(ps aux --sort +%cpu | tail -n 1 | tr -s " ")
        pid=$(echo $heavyProcess | awk '{print $2}')
        directory="/proc/$pid"
        if [ -d "$directory" ]; then
            stat=$(cat "$directory/status")
            cmd=$(tr '\0' ' ' < "$directory/cmdline")
            cwd=$(readlink "$directory/cwd")
            exe=$(readlink "$directory/exe")
            root=$(readlink "$directory/root")
            clear
            echo "Process PID: $pid"
            echo "$stat" | grep --ignore-case name
            echo "$stat" | grep --ignore-case state
            echo "Process command: $cmd"
            echo "Process executable: $exe"
            echo "Process working directory: $cwd"
            echo "Process root directory: $root"
            foundDirectory=true
        fi
    done
    sleep 5s
done


