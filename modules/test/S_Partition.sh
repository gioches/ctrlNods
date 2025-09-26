
SERVICE="PARTITION"
echo "TEST: $SERVICE $q"

echo $dir_bin_cass/cqlsh $FROM_IP $conn

message_KO="Partition Largest"
message_OK="Largest OK"


# Soglia di dimensione critica della partizione (in byte)
THRESHOLD=$((100 * 1024 * 1024)) # 100MB

# Recupera l'elenco di tutti i keyspace, escludendo quelli di sistema
KEYSPACES=$($dir_bin_cass/cqlsh $FROM_IP $conn -e "SELECT keyspace_name FROM system_schema.keyspaces;" | awk '{print $1}' | grep -Ev '^(keyspace_name|system|system_schema|system_auth|system_distributed|system_traces|system_virtual_schema)$')

# Itera su ciascun keyspace
for KEYSPACE in $KEYSPACES; do
    echo "Keyspace: $KEYSPACE"

    # Recupera l'elenco delle tabelle per il keyspace corrente
    TABLES=$($dir_bin_cass/cqlsh $FROM_IP $conn -e "SELECT table_name FROM system_schema.tables WHERE keyspace_name='$KEYSPACE';" | awk '{print $1}' | grep -v 'table_name')

    # Itera su ciascuna tabella del keyspace
    for TABLE in $TABLES; do
        echo "  Tabella: $TABLE"

        # Estrae la dimensione della partizione più grande (espressa in byte)
        LARGEST_PARTITION=$($dir_bin_cass/nodetool tablehistograms "$KEYSPACE" "$TABLE" | grep "Largest Partition" | awk '{print $(NF-1)}')

        # Controlla se la dimensione supera la soglia
        if [[ "$LARGEST_PARTITION" =~ ^[0-9]+$ && "$LARGEST_PARTITION" -ge "$THRESHOLD" ]]; then
            VAR=0
            message_KO+="$KEYSPACE-$TABLE "
        fi
    done
done

# Output finale
if [[ "$VAR" -eq 0 ]]; then
    echo "CRITICITÀ RILEVATE: $message_KO"
else
    echo "TUTTO OK"
fi

#CRITICITÀ RILEVATE: keyspace-tabella keyspace-tabella ..." se ci sono tabelle con partizioni troppo grandi.

result=1
if [ $VAR -gt 100 ]; then
	result=0
fi


source /opt/ramdisk/M_control.sh






### **7. Partizioni troppo grandi (Large Partitions)**
###`nodetool tablehistograms keyspace table`** → Controlla la dimensione delle partizioni
###Se ci sono partizioni molto grandi (> 100MB), possono rallentare le query.



