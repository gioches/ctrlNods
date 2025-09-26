
SERVICE="LATENCY"
echo "TEST: $SERVICE $q"
result=1
message_OK="QueryLAG<"


# Soglie di latenza per segnalare criticità
MAX_READ_LATENCY=3000    # Soglia per la latenza di lettura (micros)
MAX_WRITE_LATENCY=3000   # Soglia per la latenza di scrittura (micros)
MAX_RANGE_LATENCY=500    # Soglia per la latenza di range (micros)
MAX_CAS_READ_LATENCY=3000  # Soglia per la latenza di lettura CAS (micros)
MAX_CAS_WRITE_LATENCY=3000  # Soglia per la latenza di scrittura CAS (micros)
MAX_VIEW_WRITE_LATENCY=3000 # Soglia per la latenza di scrittura vista (micros)

# Esegui il comando nodetool proxyhistograms
OUTPUT=$($dir_bin_cass/nodetool proxyhistograms)
echo "$dir_bin_cass/nodetool proxyhistograms"

# Analizza l'output e cattura i valori
READ_LATENCY_95=$(echo "$OUTPUT" | grep "95%" | awk '{print $2}')
WRITE_LATENCY_95=$(echo "$OUTPUT" | grep "95%" | awk '{print $3}')
RANGE_LATENCY_95=$(echo "$OUTPUT" | grep "95%" | awk '{print $4}')
CAS_READ_LATENCY_95=$(echo "$OUTPUT" | grep "95%" | awk '{print $5}')
CAS_WRITE_LATENCY_95=$(echo "$OUTPUT" | grep "95%" | awk '{print $6}')
VIEW_WRITE_LATENCY_95=$(echo "$OUTPUT" | grep "95%" | awk '{print $7}')

READ_LATENCY_99=$(echo "$OUTPUT" | grep "99%" | awk '{print $2}')
WRITE_LATENCY_99=$(echo "$OUTPUT" | grep "99%" | awk '{print $3}')
RANGE_LATENCY_99=$(echo "$OUTPUT" | grep "99%" | awk '{print $4}')
CAS_READ_LATENCY_99=$(echo "$OUTPUT" | grep "99%" | awk '{print $5}')
CAS_WRITE_LATENCY_99=$(echo "$OUTPUT" | grep "99%" | awk '{print $6}')
VIEW_WRITE_LATENCY_99=$(echo "$OUTPUT" | grep "99%" | awk '{print $7}')

# Funzione per confrontare e segnalare le criticità
check_criticality() {
  local value=$1
  local threshold=$2
  local label=$3

value=${value%%.*}
threshold=${threshold%%.*}

  if (( $(echo "$value > $threshold" ) )); then
	echo "$value/$threshold $label"
	message_KO+="$value/$threshold $label"
	result=0
  fi
}

# Controlla le latenze per i percentili 95 e 99
check_criticality "$READ_LATENCY_95" "$MAX_READ_LATENCY" "Read Latency 95%"
check_criticality "$WRITE_LATENCY_95" "$MAX_WRITE_LATENCY" "Write Latency 95%"
check_criticality "$RANGE_LATENCY_95" "$MAX_RANGE_LATENCY" "Range Latency 95%"
check_criticality "$CAS_READ_LATENCY_95" "$MAX_CAS_READ_LATENCY" "CAS Read Latency 95%"
check_criticality "$CAS_WRITE_LATENCY_95" "$MAX_CAS_WRITE_LATENCY" "CAS Write Latency 95%"
check_criticality "$VIEW_WRITE_LATENCY_95" "$MAX_VIEW_WRITE_LATENCY" "View Write Latency 95%"

check_criticality "$READ_LATENCY_99" "$MAX_READ_LATENCY" "Read Latency 99%"
check_criticality "$WRITE_LATENCY_99" "$MAX_WRITE_LATENCY" "Write Latency 99%"
check_criticality "$RANGE_LATENCY_99" "$MAX_RANGE_LATENCY" "Range Latency 99%"
check_criticality "$CAS_READ_LATENCY_99" "$MAX_CAS_READ_LATENCY" "CAS Read Latency 99%"
check_criticality "$CAS_WRITE_LATENCY_99" "$MAX_CAS_WRITE_LATENCY" "CAS Write Latency 99%"
check_criticality "$VIEW_WRITE_LATENCY_99" "$MAX_VIEW_WRITE_LATENCY" "View Write Latency 99%"

# Opzionale: Controlla anche i valori minimi e massimi
READ_LATENCY_MIN=$(echo "$OUTPUT" | grep "Min" | awk '{print $2}')
WRITE_LATENCY_MIN=$(echo "$OUTPUT" | grep "Min" | awk '{print $3}')
RANGE_LATENCY_MIN=$(echo "$OUTPUT" | grep "Min" | awk '{print $4}')
CAS_READ_LATENCY_MIN=$(echo "$OUTPUT" | grep "Min" | awk '{print $5}')
CAS_WRITE_LATENCY_MIN=$(echo "$OUTPUT" | grep "Min" | awk '{print $6}')
VIEW_WRITE_LATENCY_MIN=$(echo "$OUTPUT" | grep "Min" | awk '{print $7}')

READ_LATENCY_MAX=$(echo "$OUTPUT" | grep "Max" | awk '{print $2}')
WRITE_LATENCY_MAX=$(echo "$OUTPUT" | grep "Max" | awk '{print $3}')
RANGE_LATENCY_MAX=$(echo "$OUTPUT" | grep "Max" | awk '{print $4}')
CAS_READ_LATENCY_MAX=$(echo "$OUTPUT" | grep "Max" | awk '{print $5}')
CAS_WRITE_LATENCY_MAX=$(echo "$OUTPUT" | grep "Max" | awk '{print $6}')
VIEW_WRITE_LATENCY_MAX=$(echo "$OUTPUT" | grep "Max" | awk '{print $7}')

# Opzionale: Controlla i minimi e massimi
check_criticality "$READ_LATENCY_MAX" "$MAX_READ_LATENCY" "Read Latency Max"
check_criticality "$WRITE_LATENCY_MAX" "$MAX_WRITE_LATENCY" "Write Latency Max"
check_criticality "$RANGE_LATENCY_MAX" "$MAX_RANGE_LATENCY" "Range Latency Max"
check_criticality "$CAS_READ_LATENCY_MAX" "$MAX_CAS_READ_LATENCY" "CAS Read Latency Max"
check_criticality "$CAS_WRITE_LATENCY_MAX" "$MAX_CAS_WRITE_LATENCY" "CAS Write Latency Max"
check_criticality "$VIEW_WRITE_LATENCY_MAX" "$MAX_VIEW_WRITE_LATENCY" "View Write Latency Max"



#Soglie di latenza: Lo script definisce delle soglie massime per le latenze di lettura, scrittura e range. Se un valore supera questa soglia, viene segnalato come criticità.
#Estrazione dei valori: Lo script esegue il comando nodetool proxyhistograms e analizza l’output utilizzando grep e awk per estrarre i valori di latenza dei percentili 50%, 75%, 95% e 99% per ciascuna metrica di latenza.
#Funzione check_criticality: La funzione confronta il valore di latenza con la soglia definita. Se il valore supera la soglia, stampa un messaggio di avviso.
#Controllo minimi e massimi: Lo script può anche verificare i valori minimi e massimi per ogni metrica di latenza, segnalando eventuali anomalie nei picchi di latenza.



echo "risultato $result"
result=0

source /opt/ramdisk/M_control.sh




### **Latenza delle query**
###`nodetool proxyhistograms`** → Mostra i tempi di risposta delle query in millisecondi:

### `Read Latency` (latenza lettura)    
### `Write Latency` (latenza scrittura)    
### `Range Latency` (query su range di dati)    
### `CAS Read/Write` (lavoro con transazioni CAS)
### Se la latenza supera un certo valore (es. 100ms), puoi inviare un alert.   




