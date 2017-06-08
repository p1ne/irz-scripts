#!/bin/bash

[ -e /mnt/rwfs/settings/settings.wifi ] && . /mnt/rwfs/settings/settings.wifi

if [ "$WIFI_MODE" = "CLIENT" ]; then
   exit 0
fi

BASE=/mnt/rwfs

. $BASE/scripts/variables.sh

. $BASE/scripts/pre-req.sh curl

MODEM_UP="1" # value inverted as we use ping return code here

#while [ "$MODEM_UP" != "1" ] ; do
#MODEM_UP=$(gsminfo | grep 'Connection state: established' | wc -l)
#sleep 5
#done

PARAM=
LAC=
LCID=

while [ -z "$PARAM" ] && [ -z "$LAC" ] && [ -z "$LCID" ]; do
  PARAM=$(cat /tmp/opinfo | grep "Current operator" | cut -d\( -f2 | tr -d \))
  MCC=$(echo $PARAM | cut -c1-3)
  MNC=$(echo $PARAM | cut -c4-5)
  LAC=$(cat /tmp/opinfo | grep LAC | cut -f2 -d\ )
  LCID=$(cat /tmp/opinfo | grep CellID | cut -f2 -d\ )
  sleep 1
done
LAC=$(printf "%d" 0x$LAC)
LCID=$(printf "%d" 0x$LCID)

while [ "$MODEM_UP" != "0" ] ; do
ping -w1 ya.ru > /dev/null
MODEM_UP=$?
done

HEADER="Content-Type: application/json"

REQUEST_BODY="json={
   \"common\": {
      \"version\": \"1.0\",
      \"api_key\": \"${YANDEX_KEY}\"
   },
   \"gsm_cells\": [
       {
          \"countrycode\": $MCC,
          \"operatorid\": $MNC,
          \"cellid\": $LCID,
          \"lac\": $LAC,
          \"age\": 5555
       }
   ]
}"

COORD=$(curl -s -i -X POST -H "$HEADER" -d "$REQUEST_BODY" http://api.lbs.yandex.net/geolocation)

LAT=$(echo "$COORD" | tr \  \\n | grep -e latitude -e longitude -A 3 | tr \\n \ | cut -f 8 -d\ | tr -d ,)
LON=$(echo "$COORD" | tr \  \\n | grep -e latitude -e longitude -A 3 | tr \\n \ | cut -f 3 -d\ | tr -d ,)

YANDEX_URL="http%3A%2F%2Fstatic-maps.yandex.ru%2F1.x%2F%3Fl%3Dmap%26pt%3D${LAT}%2C${LON}%2Cpm2ntl%26z%3D16"

if [ -x $NOTIFY_SCRIPT ] ; then
    $NOTIFY_SCRIPT "${MODEM_INTERFACE}" "Coordinates" "$YANDEX_URL"
fi


