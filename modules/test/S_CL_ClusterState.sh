#VAR=`$dir_bin_cass/nodetool status | grep -E '^D|^UJ|^UM|^UL' `
VAR=`nodetool $conn status | grep -E '^D|^UJ|^UM|^UL' `

SERVICE="CassandraSTATUS"
echo "TEST: $SERVICE $q"

#echo $VAR
message_KO="ClusterState KO $VAR"
message_OK="ClusterState OK"

err=$(echo $VAR | awk '/Datacenter: site1/ {sub("Datacenter: site1", ""); print $0}' )

#echo "righe " $err

result=1
#if [[ $err -ge 2 ]]; then
if [[ -n $err ]]; then
echo 'CassandraSTATUS result0'
	result=0
fi


source /opt/ramdisk/M_control.sh




### **1. Stato del cluster**
### `nodetool status`** → Mostra lo stato di ogni nodo nel cluster:
### ` (Up & Normal) → OK
### ` (Joining) → Nodo in fase di aggiunta
### `DN` (Down) → Nodo giù! 🚨 
###  `DE` (Leaving) → Nodo in fase di rimozione
### Se trovi un nodo `DN`, puoi impostare un alert via email o Telegram.

	#	D → Down (nodo non raggiungibile 🚨)
	#	UJ → Joining (nodo si sta unendo, ma se persiste è un problema ⚠️)
	#	UM → Moving (nodo sta spostando i dati, verifica se dura troppo ⚠️)
	#	UL → Leaving (nodo sta lasciando il cluster, ma deve completare il processo ⚠️)
