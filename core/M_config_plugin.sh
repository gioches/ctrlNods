if [ ! -f $dir_log/data.sqlite ]; then
        $dir_sqlite/sqlite3 $dir_log/data.sqlite < $dir_sqlite/schemaDB.sql;
        echo "DB created";
fi

