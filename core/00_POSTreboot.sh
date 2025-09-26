mkdir /opt/ramdisk/
mount -t tmpfs -o size=2048M tmpfs /opt/ramdisk/

mkdir -p /opt/ramdisk/bin
mkdir /opt/ramdisk/log
mkdir /opt/ramdisk/exp
mkdir -p /opt/ramdisk/modules/cassandra

cp /opt/ctrlNods/*.sh /opt/ramdisk/.
cp /opt/ctrlNods/bin/* /opt/ramdisk/bin/.
cp /opt/ctrlNods/log/* /opt/ramdisk/log/.
cp -R /opt/ctrlNods/modules/* /opt/ramdisk/modules/.

