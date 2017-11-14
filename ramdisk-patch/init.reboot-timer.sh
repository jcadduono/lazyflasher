#!/system/bin/sh

SECONDS=30

echo "Starting $SECONDS second reboot timer!"
sleep $SECONDS

echo "Rebooting to recovery after $SECONDS seconds!"
reboot recovery
