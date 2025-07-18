#!/bin/bash

heavyProcessPID=$(ps -ao pid --sort +%cpu | tail -n 1 | xargs)
directory="/proc/$heavyProcessPID"

if [ -d $directory ]; then
    cmd=$(cat $directory/cmdline)
    cwd=$(readlnk $directory/cwd)
    stat=$(cat $directory/stat)
    echo "Process PID: $heavyProcessPID"
    echo "Process command: $cmd"
    echo "Process working directory: $cwd"
    echo "Process status: $stat"

else
    echo "process with PID of $heavyProcessPID has the highest cpu consumption, but it is already finished"
fi


