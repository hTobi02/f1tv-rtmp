#!/bin/bash
while $true; do
  #Insert data from envs
  DATA=$(echo '{"Login": "'$F1TV_EMAIL'", "Password": "'$F1TV_PASSWORD'"}')
  
  #get your AccessToken
  AccessToken=$(curl -s --request POST --url https://api.formula1.com/v2/account/subscriber/authenticate/by-password --header 'Content-Type: application/json' --header 'User-Agent: RaceControl f1viewer' --header 'apiKey: fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7' --data "$DATA" | jq -r '.data.subscriptionToken')
  
  #Only stream live sessions
  ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select(.contentSubtype == "LIVE")][0].contentId')
  
  #Stream the last session
  #ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].contentId')
  
  #Get Stream URL
  URL=$(curl -s --request GET --url "https://f1tv.formula1.com/1.0/R/DEU/BIG_SCREEN_HLS/ALL/CONTENT/PLAY?contentId=$ContentId" --header "ascendontoken: $AccessToken" | jq -r '.resultObj.url')
  if [[ $URL -eq "null" ]]; then
    echo "No LiveStream"
  else
    #if [[ -v $RECORD ]]; then
      #Play session with streamlink and send it with ffmpeg to a rtmp stream server
      streamlink $URL best --hls-audio-select="de" --hls-duration 02:30:00 --record-and-pipe /dev/null | ffmpeg -hide_banner -loglevel quiet -stats -re -i pipe: -c:v copy -c:a aac -f flv rtmp://127.0.0.1:1935/live/f1tv
    #else
	#  GLOBALNAME=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO")][0].emfAttributes.Global_Title')
	#  streamlink $URL best --hls-audio-select="de" --record-and-pipe "/record/$GLOBALNAME.mp4" | ffmpeg -re -i pipe: -c:v copy -c:a aac -f flv rtmp://127.0.0.1:1935/live/f1tv
	#fi
  fi
  
  #Check status of live session every 5 minutes to avoid ip temp ban
  sleep 5m
done
