#!/bin/bash

while [ 1 ]
do
    foundDirectory=false
    while [ $foundDirectory = false ]
    do
        heavyProcess=$(ps aux --sort=+%cpu | tail -n 1 | tr -s " ")
        pid=$(echo "$heavyProcess" | awk '{print $2}')
        directory="/proc/$pid"
        if [ -d "$directory" ]; then

            # basic
            status=$(cat "$directory/status")
            cmd=$(tr '\0' ' ' < "$directory/cmdline")
            cwd=$(readlink "$directory/cwd")
            exe=$(readlink "$directory/exe")
            root=$(readlink "$directory/root")
            cpuPercent=$(echo "$heavyProcess" | awk '{print $3}')
            user=$(echo "$heavyProcess" | awk '{print $1}')

            # approximate median cpu consumption
            stat=$(cat "$directory/stat")
            uTime=$(echo "$stat" | awk '{print $14}')
            sTime=$(echo "$stat" | awk '{print $15}')
            startTime=$(echo "$stat" | awk '{print $22}')
            clockTicks=$(getconf CLK_TCK)
            upTime=$(awk '{print $1}' /proc/uptime)
            totalTime=$(echo "$uTime + $sTime" | bc -l)
            secondsAlive=$(echo "$upTime - ($startTime / $clockTicks)" | bc -l)
            medianCpuUsage=$(echo "100*(($totalTime/$clockTicks)/$secondsAlive)" | bc -l)
            name=$(echo "$status" | grep --ignore-case name | tr -s " " | awk '{print $2}')
            state=$(echo "$status" | grep --ignore-case state | tr -s " " | awk '{print $2}')
            

            # output
            clear
            echo "Process PID: $pid"
            echo "User: $user"
            echo "State: $state"
            echo "Name: $name"
            echo "Process command: $cmd"
            echo "Process executable: $exe"
            echo "Process working directory: $cwd"
            echo "Process root directory: $root"
            echo "Median CPU usage: $medianCpuUsage %"
            echo "Current CPU usage: $cpuPercent %"
            foundDirectory=true
        fi
    done
    sleep 1s
done


