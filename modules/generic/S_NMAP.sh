VAR1=`$dir_bin/nmap  $q -p 7001  | awk '/tcp/{print $2 }' `
VAR2=`$dir_bin/nmap  $q -p 7199  | awk '/tcp/{print $2 }' `
#VAR3=`$dir_bin/nmap  $q -p 9142  | awk '/tcp/{print $2 }' `

#7001   TCP     Comunicazione tra nodi con cifratura SSL abilitata
#7199   TCP     JMX (Java Management Extensions) per il monitoraggio e la gestione di Cassandra
#9142   TCP     Porta CQL per connessioni SSL/TLS


SERVICE="NMAP"
echo "TEST: $SERVICE $q"



message_KO="DOWN"
message_OK="UP"

result=1
if [ "$VAR1" != "open" ] || [ "$VAR2" != "open"  ]; then
#if [ $VAR1 != "open" ]; then
        result=0
fi


source /opt/ramdisk/M_control.sh

