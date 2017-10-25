#!/bin/sh

set -x
linkchecker --check-extern --no-robots --threads 1 --ignore-url="https://github.com/somasis/musl-wiki/.*" "$2" &
linkchecker_pid=$!
trap 'kill $linkchecker_pid' SIGINT
wait
linkchecker_exit=$?
trap - SIGINT

kill $(cat "$1"/devd.pid)
rm "$1"/devd.pid "$1"/devd.address
if [ $linkchecker_exit -ne 0 ];then
    exit 1
fi
