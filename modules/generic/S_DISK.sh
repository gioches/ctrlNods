#!/bin/bash

source /opt/ramdisk/M_config.sh

start=$(date +%s%N)
	$dir_bin/dd if=/dev/zero of=/opt/ctrlNods/testfile_100MB bs=1024 count=402400
end=$(date +%s%N)

dif=$(($(($end-$start))/1000000)) ;
#echo $dif;

qq=0;
q=$FROM_IP;
DEST_MC=($FROM_MC);

SERVICE="DISK"
echo "TEST: $SERVICE $q"
message_KO=$dif
message_OK=$dif


result=1
if [ $dif -gt 1300 ]; then
        result=0
fi


source /opt/ramdisk/M_control.sh
