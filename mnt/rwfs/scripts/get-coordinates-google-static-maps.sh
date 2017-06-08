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
MNC=$(printf "%d" $MNC)

while [ "$MODEM_UP" != "0" ] ; do
ping -w1 ${PING_HOST} > /dev/null
MODEM_UP=$?
done

HEADER="Content-Type: application/json"

REQUEST_BODY="{
  \"homeMobileCountryCode\": $MCC,
  \"homeMobileNetworkCode\": $MNC,
  \"cellTowers\": [
       {
          \"cellId\": $LCID,
          \"locationAreaCode\": $LAC,
          \"mobileCountryCode\": $MCC,
          \"mobileNetworkCode\": $MNC
       }
   ]
}"

COORD=$(curl -k -s -i -X POST -H "$HEADER" -d "$REQUEST_BODY" https://www.googleapis.com/geolocation/v1/geolocate?key=${GOOGLE_KEY})

LAT=$(echo "$COORD" | tr \  \\n | grep lat -A 1 | tr \\n \ | tr -d , | cut -f2 -d\ )
LON=$(echo "$COORD" | tr \  \\n | grep lng -A 1 | tr \\n \ | tr -d , | cut -f2 -d\ )

GOOGLE_URL="https%3A%2F%2Fmaps.googleapis.com%2Fmaps%2Fapi%2Fstaticmap%3Fcenter%3D${LAT}%2C${LON}%26zoom%3D15%26size%3D600x600%26maptype%3Droadmap%26markers%3Dcolor%3Ablue%7Clabel%3AM%7C${LAT}%2C${LON}%26key%3D${GOOGLE_KEY}"

if [ -x $NOTIFY_SCRIPT ] ; then
    $NOTIFY_SCRIPT "${MODEM_INTERFACE}" "Coordinates" "$GOOGLE_URL"
fi
