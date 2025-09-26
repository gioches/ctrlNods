VAR=`nodetool $conn gcstats | awk 'NR==2 {print $1}'`
SERVICE="MEM_GC"
echo "TEST: $SERVICE $q"

message_KO="MEM $VAR"
message_OK="MEM $VAR"

result=1
if [ "$VAR" -gt 800000 ]; then
echo "maggiore"
	result=0
fi


source /opt/ramdisk/M_control.sh




### **6. Memoria e Garbage Collection**
###`nodetool gcstats`** → Controlla la frequenza del Garbage Collector
###`Min` / `Max` / `Mean`** → Durata delle operazioni di GC
###`Count`** → Numero totale di GC eseguiti
###Se il **tempo massimo del GC** è elevato (> 1 sec), Cassandra potrebbe avere problemi di memoria  

