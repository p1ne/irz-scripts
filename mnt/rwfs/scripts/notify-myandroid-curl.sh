#!/bin/sh

BASE=/mnt/rwfs

. $BASE/scripts/variables.sh

. $BASE/scripts/pre-req.sh curl


MODEM_UP="1"

while [ "$MODEM_UP" != "0" ] ; do
#MODEM_UP=$(curl -s http://localhost | grep 'Connection state: established' | wc -l)
#sleep 5
ping -w1 ${PING_HOST} > /dev/null
MODEM_UP=$?
done

if [ ! -z "$1" ] ; then
EVENT=$1
fi

if [ ! -z "$2" ] ; then
DESC=$2
fi

if [ ! -z "$3" ] ; then
URL=$3
fi

while ! ping -c1 ${PING_HOST} &>/dev/null; do :; done

curl -s -i --data-ascii "apikey=${NMA_KEY}" --data-ascii "application=${APPLICATION}" --data-ascii "event=${EVENT}" --data-ascii "description=${DESC}" --data-ascii "url=${URL}" --data-ascii "priority=0" http://www.notifymyandroid.com/publicapi/notify > /dev/null 2>&1

