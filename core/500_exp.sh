#!/bin/bash

DB_FILE="/opt/ramdisk/log/data.sqlite"
JSON_FILE1="/opt/ramdisk/exp/exp_tutto.json"

/opt/ramdisk/bin/sqlite3 -json "$DB_FILE" "SELECT * FROM monitor " > "$JSON_FILE1"
