#echo $result;

FUNC_padre(){
	local result2="$1"
	local servizio="$2"

inverted=$((1 - result2))
adesso=$(date "+%Y-%m-%d %H:%M:%S")

local sqlpadre=`/opt/ramdisk/bin/sqlite3 /opt/ramdisk/log/data.sqlite "select id,now from monitor  where service ='$servizio' and state='$inverted'  order by now desc limit 1" `
local idpadre=$(echo "$sqlpadre" | cut -d'|' -f1)
local datapadre=$(echo "$sqlpadre" | cut -d'|' -f2)

[ -z "$datapadre" ] && datapadre=$(date "+%Y-%m-%d %H:%M:%S")
[ -z "$idpadre" ] && idpadre=0

local secondi_adesso=$(date -d "$adesso" +%s)
local secondi_padre=$(date -d "$datapadre" +%s)

local diff_secondi=$((secondi_adesso - secondi_padre))
local diff_minuti=$((diff_secondi / 60))

#local ris_FUNC_padre="$idpadre,$diff_minuti| $secondi_adesso, $secondi_padre | $adesso, $datapadre"  #DEBUG

local ris_FUNC_padre="$idpadre|$diff_minuti"

echo $ris_FUNC_padre
}

#IDpadreDurata=$(FUNC_padre "$result" "$SERVICE")
#idpadre=$(echo "$IDpadreDurata" | cut -d'|' -f1)
#durata=$(echo "$IDpadreDurata" | cut -d'|' -f2)
#echo "$idpadre $durata"


str_debug="$(date +'%m/%d/%Y %H:%M:%S')|"$SERVICE"|"$FROM_IP"|"$FROM_MC"|"$q"|"${DEST_MC[$qq]}"|"$result"|";
str_sqlite="INSERT INTO monitor VALUES(null,0,$idcluster,datetime('now','localtime'),'$SERVICE','$FROM_IP','$FROM_MC','$q','${DEST_MC[$qq]}','$result'";

#echo "controllo: $dir_log/UP_$SERVICE-$qq.ok"

if [ $result = 0 ]; then
#service 0 DOWN

        #if not exist UP_.ok 
        if [ -f $dir_log/UP_$SERVICE-$qq.ok ]; then
                # service previously active -> NOW IS KO -> remove file.ok + write log
                rm $dir_log/UP_$SERVICE-$qq.ok

		IDpadreDurata=$(FUNC_padre "$result" "$SERVICE")
		idpadre=$(echo "$IDpadreDurata" | cut -d'|' -f1)
		durata=$(echo "$IDpadreDurata" | cut -d'|' -f2)

        	str_sqlite2="$str_sqlite ,'$message_KO','$idpadre','$durata' );";
		echo $str_debug $message_KO;
		echo $str_debug $message_KO >> $dir_log/data.log
		$dir_sqlite/sqlite3 $dir_log/data.sqlite "$str_sqlite2";

		MESSAGE_CHAT="$MESSAGE  $str_sqlite"
		#echo $MESSAGE_CHAT
		#curl -H "Content-Type: application/json" -d '{"text": "'"$MESSAGE_CHAT"'"}' $WEBHOOK_URL

        fi
else
#service 1 UP

        #if not exist UP_.ok
        if [ -f $dir_log/UP_$SERVICE-$qq.ok  ]; then
        # service previously active -> don't do anything
        echo 1 > /dev/null

else
        # service not previously active -> NOW IS OK -> create file.ok + write log
        echo 1 > $dir_log/UP_$SERVICE-$qq.ok

                IDpadreDurata=$(FUNC_padre "$result" "$SERVICE")
                idpadre=$(echo "$IDpadreDurata" | cut -d'|' -f1)
                durata=$(echo "$IDpadreDurata" | cut -d'|' -f2)

                str_sqlite2="$str_sqlite ,'$message_OK','$idpadre','$durata');";
                echo $str_debug $message_OK;
                echo $str_debug $message_OK >> $dir_log/data.log
                $dir_sqlite/sqlite3 $dir_log/data.sqlite "$str_sqlite2";

	fi

 fi
