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
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select(.contentSubtype == "LIVE")][0].contentId')
  else
    #Stream the last session
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].contentId')
  fi

  #Get Stream URL
  URL=$(curl -s --request GET --url "https://f1tv.formula1.com/1.0/R/DEU/BIG_SCREEN_HLS/ALL/CONTENT/PLAY?contentId=$ContentId" --header "ascendontoken: $AccessToken" | jq -r '.resultObj.url')
  if [ "$URL" = "null" ]
  then
    echo "ERROR: URL is null. Maybe there is no live stream?"
    exit
  fi
  if [ $RECORD = "true" ]; then
    GLOBALNAME=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].emfAttributes.Global_Title')
    echo GLOBALNAME: "$GLOBALNAME"
    ffmpeg -hide_banner -n -i "$URL" -map 0:p:5:v -map 0:a -c copy "$OUTPUT/$GLOBALNAME.mp4"
  elif [ $RECORD = "false" ]; then
    #Play session with ffmpeg and send it to a rtmp stream server
    ffmpeg -hide_banner -re -i "$URL" -map 0:p:5:v -map "$MAP" -c:v copy -c:a aac -f flv $OUTPUT
  else
    echo "error"
  fi

  #Check status of live session every 5 minutes to avoid ip temp ban
  #echo "---- DEBUG ----"
  #echo DATA: "$DATA"
  #echo AccessToken: "$AccessToken"
  #echo ContentId "$ContentId"
  #echo URL: "$URL"
  sleep 5m
done
