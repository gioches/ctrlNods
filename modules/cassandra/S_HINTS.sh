SERVICE="HINTS"
echo "TEST: $SERVICE $q"

#HINTS_DIR="/opt/ramdisk/log"
HINTS_DIR="/var/lib/cassandra/hints"

HINTS_FILES=("$HINTS_DIR"/hints-*)

COUNT=0
DATES=""
KEYSPACE_TABLES=""


# Ciclo sui file
for FILE in "${HINTS_FILES[@]}"; do
    # Verifica se il file esiste
    [ -e "$FILE" ] || continue

    # Incrementa il contatore
    COUNT=$((COUNT + 1))
    
    # Estrazione del timestamp dal nome del file usando una regex migliorata
    TIMESTAMP=$(echo "$FILE" | sed -E 's/.*-([0-9]{13})-.*\.db/\1/')

    # Verifica che il timestamp sia valido (13 cifre)
    if [[ ! "$TIMESTAMP" =~ ^[0-9]{13}$ ]]; then
        echo "Errore: Il file $FILE non contiene un timestamp valido."
        continue
    fi

    # Dividere il timestamp per 1000 per ottenere il valore in secondi
    TIMESTAMP_SECONDS=$(($TIMESTAMP / 1000))

    # Convertire il timestamp in secondi in una data leggibile
    HUMAN_DATE=$(date -d @$TIMESTAMP_SECONDS '+%Y-%m-%d %H:%M:%S')

    # Estrazione di keyspace e tabella dal nome del file
    KEYSPACE=$(echo "$FILE" | sed -E 's/.*-(.*)-(.*)\.db/\1/')
    TABLE=$(echo "$FILE" | sed -E 's/.*-(.*)-(.*)\.db/\2/')

    # Concatenare il risultato in una variabile
    CONCATENATED_RESULTS+="$HUMAN_DATE  $KEYSPACE-$TABLE; "
done

	# Rimuovere l'ultimo separatore "; " dalla concatenazione finale
	CONCATENATED_RESULTS=$(echo $CONCATENATED_RESULTS | sed 's/; $//')

# Mostrare il risultato concatenato
#echo "$CONCATENATED_RESULTS"

# Mostrare il conteggio finale
#echo "Count: $COUNT"

if [ "$COUNT" -gt 0 ]; then
    result=0
    message_KO="$COUNT $CONCATENATED_RESULTS"
else
    result=1
    message_OK="ONLINE"
fi

#echo risultato= $result


source /opt/ramdisk/M_control.sh




