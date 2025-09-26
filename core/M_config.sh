#!/bin/bash

# ----------- Cluster and Node Data -----------

dir_bin_cass=""
idcluster="9991"
DEST_IP=(
    "10.251.224.244"
    "10.251.224.245"
    "10.251.224.246"
)
DEST_MC=(
    "torino"
    "torino"
    "torino"
)
FROM_IP="10.251.224.246"
FROM_MC="roma"

# ---- Application file paths ------------

dir_sqlite="/opt/ramdisk/bin"
dir_log="/opt/ramdisk/log"
dir_bin="/opt/ramdisk/bin"
dir_mod="/opt/ramdisk/modules"
conn=" --ssl -u cassandra -pw Pegasus1 "


#---------------
source /opt/ramdisk/M_config_plugin.sh
