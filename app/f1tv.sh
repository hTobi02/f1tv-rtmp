#!/bin/bash

#Insert data from envs
if [ -z $F1TV_EMAIL ]; then
  echo "No E-Mail set. exiting..."
  exit
fi
if [ -z $F1TV_PASSWORD ]; then
  echo "No Password set. exiting..."
  exit
fi
if [ -z $LANGUAGE ]; then
  LANGUAGE=eng
fi
if [ -z $LIVE ]; then
  LIVE=true
fi
if [ -z $RECORD ]; then
  RECORD=false
fi
if [[ -z $OUTPUT && $RECORD == true ]]; then
  OUTPUT='/record'
elif [[ -z $OUTPUT && $RECORD == false ]]; then
  OUTPUT='rtmp://127.0.0.1:1935/live/f1tv'
fi

DATA=$(echo '{"Login": "'$F1TV_EMAIL'", "Password": "'$F1TV_PASSWORD'"}')
MAP="0:m:language:$LANGUAGE?"

echo "---- SETTINGS ----"
echo DATA: "$DATA"
echo MAP: "$MAP"
echo LIVE: "$LIVE"
echo RECORD: "$RECORD"
echo OUTPUT: "$OUTPUT"

while $true; do
  #Get your AccessToken
  AccessToken=$(curl -s --request POST --url https://api.formula1.com/v2/account/subscriber/authenticate/by-password --header 'Content-Type: application/json' --header 'User-Agent: RaceControl f1viewer' --header 'apiKey: fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7' --data "$DATA" | jq -r '.data.subscriptionToken')
  
  if [ $LIVE = "true" ]
  then
    #Only stream live sessions
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select((.titleBrief == "Rennen") or (.titleBrief == "Qualifying") or (.titleBrief | startswith("Training"))) | select(.contentSubtype == "LIVE")][0].contentId')
  else
    #Stream the last session
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select((.titleBrief == "Rennen") or (.titleBrief == "Qualifying") or (.titleBrief | startswith("Training")))][0].contentId')
  fi

  if [ "$ContentId" = "null" ]
  then
    echo "ERROR: URL is null. Maybe there is no live stream?"
  else
    #Get Stream URL
    URL=$(curl -s --request GET --url "https://f1tv.formula1.com/1.0/R/DEU/BIG_SCREEN_HLS/ALL/CONTENT/PLAY?contentId=$ContentId" --header "ascendontoken: $AccessToken" | jq -r '.resultObj.url')
    if [ $RECORD = "true" ]; then
      GLOBALNAME=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].emfAttributes.Global_Title')
      echo GLOBALNAME: "$GLOBALNAME"
      ffmpeg -hide_banner -loglevel warning -stats -n -i "$URL" -map 0:p:5:v -map 0:a -c copy "$OUTPUT/$GLOBALNAME.mp4"
    elif [ $RECORD = "false" ]; then
      #Play session with ffmpeg and send it to a rtmp stream server
      echo '#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=415000,RESOLUTION=480x270
streams/f1tv_mini.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=677000,RESOLUTION=512x288
streams/f1tv_low.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1200000,RESOLUTION=640x360
streams/f1tv_mid.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1993000,RESOLUTION=960x540
streams/f1tv_high.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=3730000,RESOLUTION=1280x720
streams/f1tv_hd.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=6286000,RESOLUTION=1920x1080
streams/f1tv_fhd.m3u8
' > /srv/www/f1tv.m3u8
      ffmpeg -y -hide_banner -loglevel warning -re -i "$URL" \
-map 0:p:5:v -map "$MAP" -c:v copy -c:a aac -f flv $OUTPUT \
-map 0:p:5:v -map "$MAP" -c:v copy -c:a aac -f hls -hls_time 5 -hls_list_size 50 -hls_flags delete_segments /srv/www/streams/f1tv_fhd.m3u8 \
-map 0:p:4:v -map "$MAP" -c:v copy -c:a aac -f hls -hls_time 5 -hls_list_size 50 -hls_flags delete_segments /srv/www/streams/f1tv_hd.m3u8 \
-map 0:p:3:v -map "$MAP" -c:v copy -c:a aac -f hls -hls_time 5 -hls_list_size 50 -hls_flags delete_segments /srv/www/streams/f1tv_high.m3u8 \
-map 0:p:0:v -map "$MAP" -c:v copy -c:a aac -f hls -hls_time 5 -hls_list_size 50 -hls_flags delete_segments /srv/www/streams/f1tv_mid.m3u8 \
-map 0:p:2:v -map "$MAP" -c:v copy -c:a aac -f hls -hls_time 5 -hls_list_size 50 -hls_flags delete_segments /srv/www/streams/f1tv_low.m3u8 \
-map 0:p:1:v -map "$MAP" -c:v copy -c:a aac -f hls -hls_time 5 -hls_list_size 50 -hls_flags delete_segments /srv/www/streams/f1tv_mini.m3u8
echo '#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=415000,RESOLUTION=480x270
streams/idle.m3u8
' > /srv/www/f1tv.m3u8
    else
      echo "error"
    fi
  fi

  echo "---- DEBUG ----"
  echo "AccessToken: $AccessToken"
  echo "ContentId $ContentId"
  echo "URL: $URL"
  
  #Check status of live session every 5 minutes to avoid ip temp ban
  sleep 5m
done
