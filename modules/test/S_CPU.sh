VAR1=`top -b -n 1 | grep java | awk '{print $9}'`
sleep 1

VAR2=`top -b -n 1 | grep java | awk '{print $9}'`
sleep 1

VAR3=`top -b -n 1 | grep java | awk '{print $9}'`
sleep 1


VAR1_INT=${VAR1%%.*}
VAR2_INT=${VAR2%%.*}
VAR3_INT=${VAR3%%.*}


SERVICE="CPU"
echo "TEST: $SERVICE $q"

message_KO="CPU $VAR1 $VAR2 $VAR3"
message_OK="CPU OK"

result=1
if [[ $VAR1_INT -gt 30 || $VAR2_INT -gt 30 || $VAR3_INT -gt 30 ]]; then
        result=0
fi


source /opt/ramdisk/M_control.sh

### **5. Utilizzo della CPU**
###`top`** e **`mpstat`** → Monitorano l'uso della CPU
###`%usr`** → CPU usata dai processi dell'utente    
###`%sys`** → CPU usata dal sistema    
###`%iowait`** → CPU in attesa di operazioni su disco    
### Se la CPU supera l'70%, il nodo potrebbe essere sovraccarico.

