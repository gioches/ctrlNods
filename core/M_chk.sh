#!/bin/bash

source  /opt/ramdisk/M_config.sh

qq=0;

for q in "${DEST_IP[@]}"
do
	#ctr nodi

	source $dir_mod/generic/S_PING.sh
	source $dir_mod/generic/S_NMAP.sh

let qq++;
done

qq=0
	#ctrl se stesso
	
	#source $dir_mod/generic/S_DISK.sh
        #source $dir_mod/cassandra/S_HINTS.sh
	
	#source $dir_mod/test/S_MEM.sh
	#source $dir_mod/test/S_CPU.sh
	
	#source $dir_mod/test/S_Partition.sh #errori da verificare
	#source $dir_mod/test/S_Balancing.sh
	#source $dir_mod/test/S_CL_ClusterState.sh
	#source $dir_mod/test/S_CL_QueryLatency.sh
	#source $dir_mod/test/S_QueryQueue.sh



# Set your schedule times here
ONCE_DAILY="03:30"
TWICE_DAILY=("10:15" "15:45")
THRICE_DAILY=("08:00" "12:30" "21:45")

CURRENT_TIME=$(date +%H:%M)




if [[ "$CURRENT_TIME" == "$ONCE_DAILY" ]]; then
    echo "Executing once-daily scripts at $CURRENT_TIME"

    # source ""
    # source ""
fi

# Check for twice daily schedule
for time in "${TWICE_DAILY[@]}"; do
    if [[ "$CURRENT_TIME" == "$time" ]]; then
        echo "Executing twice-daily scripts at $CURRENT_TIME"
        
        # source ""
    	# source ""
    fi
done

# Check for thrice daily schedule
for time in "${THRICE_DAILY[@]}"; do
    if [[ "$CURRENT_TIME" == "$time" ]]; then
        echo "Executing thrice-daily scripts at $CURRENT_TIME"
        
        # source ""
    	# source ""
    fi
done
