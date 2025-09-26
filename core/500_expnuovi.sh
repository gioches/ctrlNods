#!/bin/bash

DB_FILE="/opt/ramdisk/log/data.sqlite"
JSON_FILE="/opt/ramdisk/exp/exp_"$(date "+%Y%m%d%H%M").json


/opt/ramdisk/bin/sqlite3 -json "$DB_FILE" "SELECT * FROM monitor WHERE sync = 0; " > "$JSON_FILE"
/opt/ramdisk/bin/sqlite3 -json "$DB_FILE" "UPDATE  monitor SET sync=1 WHERE sync = 0; "
