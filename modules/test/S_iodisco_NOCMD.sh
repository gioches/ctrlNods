VAR=`iostat -dx 1 5 | grep sda | awk '{print $10}'`
SERVICE="IO DISK"
echo "TEST: $SERVICE $q"


message_KO="IO>"
message_OK="IO<"

result=1
if [ $VAR -gt 10 ]; then
	result=0
fi


source /opt/ramdisk/M_control.sh


### **4. I/O su disco**
###`iostat -dx 1`** → Controlla il tempo di attesa del disco (latenza I/O)
###`await`** → Tempo medio di attesa per operazioni di lettura/scrittura    
###`svctm`** → Tempo medio di servizio per operazione
### Se il valore `await` è alto (>10ms), potrebbe esserci un problema di I/O con il disco.
    


