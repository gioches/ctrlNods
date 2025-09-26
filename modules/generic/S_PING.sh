VAR=`$dir_bin/ping -c 2 $q > /dev/null; echo $?`
SERVICE="PING"
echo "TEST: $SERVICE $q"


message_KO="OFFLINE"
message_OK="ONLINE"

result=1
if [ $VAR -ne 0 ]; then
	result=0
fi


source /opt/ramdisk/M_control.sh
