VAR=`$dir_bin_cass/nodetool tpstats  | awk 'NR>1 && ($3+0 > 0 || $5+0 > 0) {print "Attenzione:", $1, "Pending:", $3, "Blocked:", $5}' `
SERVICE="TCPSTAT_Pending"
echo "TEST: $SERVICE $q"


message_KO="$VAR"
message_OK="Pendig OK"

result=1
if [ $VAR -gt 1 ]; then
	result=0
fi


source /opt/ramdisk/M_control.sh


### **3. Numero di query in coda**
### `nodetool tpstats`** → Mostra i thread pool delle query
###  `Pending` → Query in attesa di essere elaborate  
###  `Completed` → Query completate
###  `Dropped` → Query scartate 🚨
   

# Pool Name                         Active   XXPending      Completed   XXBlocked  All time blocked
# ReadStage                              0         0         244524         0                 0
# MiscStage                              0         0              0         0                 0
# CompactionExecutor                     0         0          23322         0                 0
# MutationStage                          0         0         150732         0                 0
# MemtableReclaimMemory                  0         0             39         0                 0
# PendingRangeCalculator                 0         0              3         0                 0
# GossipStage                            0         0          33908         0                 0
# SecondaryIndexManagement               0         0              0         0                 0
# HintsDispatcher                        0         0              0         0                 0
# RequestResponseStage                   0         0         164819         0                 0
# Native-Transport-Requests              0         0         257031         0                 0
# ReadRepairStage                        0         0          20643         0                 0
# CounterMutationStage                   0         0             84         0                 0
# MigrationStage                         0         0              0         0                 0
# MemtablePostFlush                      0         0             40         0                 0
# PerDiskMemtableFlushWriter_0           0         0             39         0                 0
# ValidationExecutor                     0         0              0         0                 0
# Sampler                                0         0              0         0                 0
# MemtableFlushWriter                    0         0             39         0                 0
# InternalResponseStage                  0         0              0         0                 0
# ViewMutationStage                      0         0              0         0                 0
# AntiEntropyStage                       0         0              0         0                 0
# CacheCleanupExecutor                   0         0              0         0                 0


