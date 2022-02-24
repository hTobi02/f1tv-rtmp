#!/bin/bash

#if [[ $LANGUAGE="deu" ]]; then
#  MAP="0:18"
#elif [[ $LANGUAGE="fra" ]]; then
#  MAP="0:19"
#elif [[ $LANGUAGE="spa" ]]; then
#  MAP="0:20"
#elif [[ $LANGUAGE="nld" ]]; then
#  MAP="0:21"
#elif [[ $LANGUAGE="por" ]]; then
#  MAP="0:22"
#elif [[ $LANGUAGE="eng" ]]; then
#  MAP="0:24"
#else
#  MAP="0:23"
#fi

#Insert data from envs
DATA=$(echo '{"Login": "'$F1TV_EMAIL'", "Password": "'$F1TV_PASSWORD'"}')
MAP="0:m:language:$LANGUAGE?"

echo "---- SETTINGS ----"
echo DATA: $DATA
echo MAP: $MAP
echo LIVE: $LIVE
echo RECORD: $RECORD
while $true; do
  
  #Get your AccessToken
  AccessToken=$(curl -s --request POST --url https://api.formula1.com/v2/account/subscriber/authenticate/by-password --header 'Content-Type: application/json' --header 'User-Agent: RaceControl f1viewer' --header 'apiKey: fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7' --data "$DATA" | jq -r '.data.subscriptionToken')
  
  if [ $LIVE = "true" ]; then
    #Only stream live sessions
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select(.contentSubtype == "LIVE")][0].contentId')
  else
    #Stream the last session
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].contentId')
  fi

  #Get Stream URL
  URL=$(curl -s --request GET --url "https://f1tv.formula1.com/1.0/R/DEU/BIG_SCREEN_HLS/ALL/CONTENT/PLAY?contentId=$ContentId" --header "ascendontoken: $AccessToken" | jq -r '.resultObj.url')
  if [[ $URL -eq "null" ]]; then
    echo "ERROR: URL is null. Maybe there is no live stream?"
  else
    if [ $RECORD = "true" ]; then
      GLOBALNAME=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].emfAttributes.Global_Title')
      echo GLOBALNAME: $GLOBALNAME
      ffmpeg -hide_banner -n -i $URL -map 0:p:5:v -map 0:a -c copy "/record/$GLOBALNAME.mp4"
    else
      #Play session with ffmpeg and send it to a rtmp stream server
      ffmpeg -hide_banner -re -i $URL -map 0:p:5:v -map $MAP -c:v copy -c:a aac -f flv rtmp://127.0.0.1:1935/live/f1tv
	fi
  fi
  
  #Check status of live session every 5 minutes to avoid ip temp ban
  sleep 5m
done
