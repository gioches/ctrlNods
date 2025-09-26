VAR=`$dir_bin_cass/nodetool netstats | grep -E 'Receiving from|Sending to' `

SERVICE="BALANCING"
echo "TEST: $SERVICE $q"


message_KO="Balancing KO"
message_OK="Balancing OK"

result=1
if [[ -n "$VAR" ]]; then
	result=0
fi

source /opt/ramdisk/M_control.sh


### **8. Streaming e bilanciamento del cluster**
###`nodetool netstats`** → Controlla lo stato del trasferimento dati tra i nodi
###Se vedi **"Receiving from"** o **"Sending to"**, significa che un nodo sta ricevendo o inviando dati.    
### Se lo streaming è troppo lungo, il nodo potrebbe essere sovraccarico.
    



