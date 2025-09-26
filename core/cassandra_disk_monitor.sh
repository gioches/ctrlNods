#!/bin/bash

# Script per monitorare l'utilizzo del disco di /data/cassandra
# e salvare i dati in un file CSV

# Configurazione
CSV_FILE="/opt/ctrlNods/cassandra_data_usage.csv"
MOUNT_POINT="/cassandra"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DATE_ONLY=$(date '+%Y-%m-%d')

# Funzione per inizializzare il file CSV con header
init_csv() {
    if [ ! -f "$CSV_FILE" ]; then
        echo "timestamp,filesystem,mount_point,total_size,used_space,available_space,use_percentage" > "$CSV_FILE"
        echo "✓ File CSV creato: $CSV_FILE"
    fi
}

# Funzione principale per salvare i dati
save_disk_usage() {
    echo "Recupero dati utilizzo disco per $MOUNT_POINT..."
    
    # Esegui df e filtra per /data/cassandra (usa $ per match esatto)
    line=$(df -h | grep "${MOUNT_POINT}$")
    
    if [ -z "$line" ]; then
        echo "✗ Mount point $MOUNT_POINT non trovato"
        exit 1
    fi
    
    # Estrai i campi dalla riga
    filesystem=$(echo "$line" | awk '{print $1}')
    total_size=$(echo "$line" | awk '{print $2}')
    used_space=$(echo "$line" | awk '{print $3}')
    available_space=$(echo "$line" | awk '{print $4}')
    use_percentage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    mount_point=$(echo "$line" | awk '{print $6}')
    
    echo ""
    echo "Dati trovati:"
    echo "  Filesystem: $filesystem"
    echo "  Spazio totale: $total_size"
    echo "  Spazio usato: $used_space"
    echo "  Spazio disponibile: $available_space"
    echo "  Percentuale uso: $use_percentage%"
    
    # Aggiungi riga al CSV
    echo "$TIMESTAMP,$filesystem,$mount_point,$total_size,$used_space,$available_space,$use_percentage" >> "$CSV_FILE"
    
    echo ""
    echo "✓ Dati salvati in $CSV_FILE"
}

# Funzione per visualizzare gli ultimi record
show_recent_data() {
    if [ ! -f "$CSV_FILE" ]; then
        echo "✗ File CSV non trovato: $CSV_FILE"
        return
    fi
    
    echo ""
    echo "Ultimi 20 record:"
    echo "--------------------------------------------------------------------------------"
    echo "Timestamp                | Spazio Usato | Disponibile | Uso %"
    echo "--------------------------------------------------------------------------------"
    
    # Ultimi 20 record (escluso header)
    tail -n +2 "$CSV_FILE" | tail -20 | while IFS=',' read -r timestamp filesystem mount_point total_size used_space available_space use_percentage; do
        printf "%-24s | %-12s | %-11s | %3s%%\n" "$timestamp" "$used_space" "$available_space" "$use_percentage"
    done
}

# Funzione per mostrare statistiche
show_statistics() {
    if [ ! -f "$CSV_FILE" ]; then
        echo "✗ File CSV non trovato: $CSV_FILE"
        exit 1
    fi
    
    echo ""
    echo "Statistiche per $MOUNT_POINT:"
    echo "--------------------------------------------------------------------------------"
    
    # Conta record totali
    total_records=$(($(wc -l < "$CSV_FILE") - 1))
    
    # Trova min e max per percentuale
    min_perc=$(tail -n +2 "$CSV_FILE" | cut -d',' -f7 | sort -n | head -1)
    max_perc=$(tail -n +2 "$CSV_FILE" | cut -d',' -f7 | sort -n | tail -1)
    
    # Primo e ultimo record
    first_record=$(tail -n +2 "$CSV_FILE" | head -1)
    last_record=$(tail -n +2 "$CSV_FILE" | tail -1)
    
    first_date=$(echo "$first_record" | cut -d',' -f1)
    first_used=$(echo "$first_record" | cut -d',' -f5)
    last_date=$(echo "$last_record" | cut -d',' -f1)
    last_used=$(echo "$last_record" | cut -d',' -f5)
    
    echo "  Record totali: $total_records"
    echo "  Periodo: $first_date -> $last_date"
    echo "  Spazio usato iniziale: $first_used"
    echo "  Spazio usato attuale: $last_used"
    echo "  Percentuale Min/Max: $min_perc% / $max_perc%"
    echo ""
    
    # Calcola media percentuale
    if [ $total_records -gt 0 ]; then
        avg_perc=$(tail -n +2 "$CSV_FILE" | cut -d',' -f7 | awk '{sum+=$1} END {printf "%.1f", sum/NR}')
        echo "  Percentuale media: $avg_perc%"
    fi
}

# Funzione per mostrare l'andamento giornaliero
show_daily_trend() {
    if [ ! -f "$CSV_FILE" ]; then
        echo "✗ File CSV non trovato: $CSV_FILE"
        exit 1
    fi
    
    echo ""
    echo "Andamento giornaliero spazio usato (ultimi 30 giorni):"
    echo "--------------------------------------------------------------------------------"
    echo "Data        | Prima Lettura | Ultima Lettura | Delta Giornaliero"
    echo "--------------------------------------------------------------------------------"
    
    # Mostra evoluzione giornaliera
    tail -n +2 "$CSV_FILE" | \
    awk -F',' '{
        date = substr($1, 1, 10)
        if (date != last_date && last_date != "") {
            if (daily_first[last_date] && daily_last[last_date]) {
                printf "%s | %-13s | %-14s | %s -> %s\n", 
                    last_date, 
                    daily_first[last_date], 
                    daily_last[last_date],
                    daily_first_perc[last_date] "%",
                    daily_last_perc[last_date] "%"
            }
        }
        if (!daily_first[date]) {
            daily_first[date] = $5
            daily_first_perc[date] = $7
        }
        daily_last[date] = $5
        daily_last_perc[date] = $7
        last_date = date
    }
    END {
        if (daily_first[last_date] && daily_last[last_date]) {
            printf "%s | %-13s | %-14s | %s -> %s\n", 
                last_date, 
                daily_first[last_date], 
                daily_last[last_date],
                daily_first_perc[last_date] "%",
                daily_last_perc[last_date] "%"
        }
    }' | tail -30
}

# Funzione per creare report settimanale
create_weekly_report() {
    if [ ! -f "$CSV_FILE" ]; then
        echo "✗ File CSV non trovato: $CSV_FILE"
        exit 1
    fi
    
    local week_ago=$(date -d "7 days ago" '+%Y-%m-%d')
    local report_file="cassandra_weekly_report_${DATE_ONLY}.txt"
    
    {
        echo "REPORT SETTIMANALE SPAZIO DISCO CASSANDRA"
        echo "=========================================="
        echo "Data Report: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Mount Point: $MOUNT_POINT"
        echo ""
        
        # Estrai dati ultima settimana
        echo "DATI ULTIMA SETTIMANA:"
        echo "----------------------"
        
        # Primo record della settimana
        first_week=$(tail -n +2 "$CSV_FILE" | awk -F',' -v date="$week_ago" '$1 >= date' | head -1)
        if [ -n "$first_week" ]; then
            echo "Inizio settimana:"
            echo "  Data: $(echo "$first_week" | cut -d',' -f1)"
            echo "  Spazio usato: $(echo "$first_week" | cut -d',' -f5)"
            echo "  Percentuale: $(echo "$first_week" | cut -d',' -f7)%"
        fi
        
        # Ultimo record
        last_week=$(tail -1 "$CSV_FILE")
        echo ""
        echo "Fine settimana:"
        echo "  Data: $(echo "$last_week" | cut -d',' -f1)"
        echo "  Spazio usato: $(echo "$last_week" | cut -d',' -f5)"
        echo "  Percentuale: $(echo "$last_week" | cut -d',' -f7)%"
        
        echo ""
        echo "STATISTICHE SETTIMANALI:"
        echo "------------------------"
        
        # Min/Max della settimana
        week_data=$(tail -n +2 "$CSV_FILE" | awk -F',' -v date="$week_ago" '$1 >= date')
        if [ -n "$week_data" ]; then
            min_week=$(echo "$week_data" | cut -d',' -f7 | sort -n | head -1)
            max_week=$(echo "$week_data" | cut -d',' -f7 | sort -n | tail -1)
            avg_week=$(echo "$week_data" | cut -d',' -f7 | awk '{sum+=$1; count++} END {printf "%.1f", sum/count}')
            
            echo "  Min: $min_week%"
            echo "  Max: $max_week%"
            echo "  Media: $avg_week%"
        fi
        
    } > "$report_file"
    
    echo "✓ Report settimanale creato: $report_file"
    cat "$report_file"
}

# Funzione per alert se supera soglia
check_threshold() {
    local threshold="${1:-80}"
    
    # Ottieni ultima percentuale
    if [ -f "$CSV_FILE" ]; then
        last_percentage=$(tail -1 "$CSV_FILE" | cut -d',' -f7)
        last_used=$(tail -1 "$CSV_FILE" | cut -d',' -f5)
        
        if [ "$last_percentage" -gt "$threshold" ]; then
            echo "⚠️  ALERT: Spazio usato sopra soglia!"
            echo "   Mount point: $MOUNT_POINT"
            echo "   Soglia: $threshold%"
            echo "   Uso attuale: $last_percentage% ($last_used)"
            return 1
        else
            echo "✓ Spazio disco OK: $last_percentage% usati ($last_used)"
            return 0
        fi
    fi
}

# Funzione di aiuto
show_help() {
    cat <<EOF
Utilizzo: $0 [OPZIONE]

Script per monitorare lo spazio disco di $MOUNT_POINT e salvare in CSV.

OPZIONI:
    -h, --help           Mostra questo messaggio di aiuto
    -s, --stats          Mostra statistiche complete
    -r, --recent         Mostra ultimi 20 record
    -d, --daily          Mostra andamento giornaliero
    -w, --weekly         Crea report settimanale
    -c, --check [soglia] Controlla se supera soglia (default: 80%)
    
Senza opzioni, salva i dati correnti nel CSV.

ESEMPI:
    $0                   # Salva i dati correnti
    $0 --stats           # Mostra statistiche
    $0 --daily           # Mostra trend giornaliero
    $0 --check 75        # Alert se uso > 75%
    
CRONTAB:
    # Ogni ora
    0 * * * * /path/to/$0
    
    # Ogni 30 minuti con check soglia
    */30 * * * * /path/to/$0 && /path/to/$0 --check 80
    
    # Report settimanale ogni lunedì
    0 9 * * 1 /path/to/$0 --weekly

FILE CSV: $CSV_FILE
MOUNT POINT: $MOUNT_POINT
EOF
}

# Main
main() {
    # Gestisci parametri
    case "${1:-}" in
        -h|--help)
            show_help
            ;;
        -s|--stats)
            show_statistics
            ;;
        -r|--recent)
            show_recent_data
            ;;
        -d|--daily)
            show_daily_trend
            ;;
        -w|--weekly)
            create_weekly_report
            ;;
        -c|--check)
            check_threshold "${2:-80}"
            ;;
        "")
            # Comportamento di default: salva dati
            init_csv
            save_disk_usage
            show_recent_data
            ;;
        *)
            echo "✗ Opzione non valida: $1"
            echo "Usa -h o --help per l'aiuto"
            exit 1
            ;;
    esac
}

# Esegui main
main "$@"
