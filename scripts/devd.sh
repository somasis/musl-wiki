#!/bin/sh
set -x
nohup devd -t "$1" > "$1"/devd.log &
echo $! > "$1"/devd.pid
sleep 1
sed -r '/Listening/!d;s/Listening on (.+) .*/\1/' "$1"/devd.log > "$1"/devd.address
