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
if [ -z $HLS ]; then
  HLS=false
fi
if [[ -z $OUTPUT && $RECORD == true ]]; then
  OUTPUT='/record'
elif [[ -z $OUTPUT && $RECORD == false ]]; then
  OUTPUT='rtmp://127.0.0.1:1935/live/f1tv'
fi
if [ -z $REPLAY ]; then
  REPLAY=false
fi

DATA=$(echo '{"Login": "'$F1TV_EMAIL'", "Password": "'$F1TV_PASSWORD'"}')
MAP="0:m:language:$LANGUAGE?"

echo "---- SETTINGS ----"
#echo DATA: "$DATA"
echo MAP: "$MAP"
echo LIVE: "$LIVE"
echo RECORD: "$RECORD"
echo OUTPUT: "$OUTPUT"
echo REPLAY: "$REPLAY"
echo HLS: "$HLS"

while $true; do
  #Get your AccessToken
  AccessToken=$(curl -s --request POST --url https://api.formula1.com/v2/account/subscriber/authenticate/by-password --header 'Content-Type: application/json' --header 'User-Agent: RaceControl f1viewer' --header 'apiKey: fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7' --data "$DATA" | jq -r '.data.subscriptionToken')
  GLOBALNAME=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select((.titleBrief == "Rennen") or (.titleBrief == "Qualifying") or (.titleBrief == "Sprintrennen") or (.titleBrief | startswith("Training")))][0].emfAttributes.Global_Title')
  
  if [ $LIVE = "true" ]
  then
    #Only stream live sessions
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select((.titleBrief == "Rennen") or (.titleBrief == "Qualifying") or (.titleBrief == "Sprintrennen") or (.titleBrief | startswith("Training"))) | select(.contentSubtype == "LIVE")][0].contentId')
    bash /app/watch.sh "$GLOBALNAME" &
  else
    #Stream the last session
    ContentId=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select((.titleBrief == "Rennen") or (.titleBrief == "Qualifying") or (.titleBrief == "Sprintrennen") or (.titleBrief | startswith("Training")))][0].contentId')
  fi
  
  if [ "$ContentId" = "null" ]
  then
    echo "ERROR: URL is null. Maybe there is no live stream?"
  else
    #Get Stream URL
    URL=$(curl -s --request GET --url "https://f1tv.formula1.com/1.0/R/DEU/BIG_SCREEN_HLS/ALL/CONTENT/PLAY?contentId=$ContentId" --header "ascendontoken: $AccessToken" | jq -r '.resultObj.url')
    if [ $RECORD = "true" ]; then
      echo GLOBALNAME: "$GLOBALNAME"
      ffmpeg -hide_banner -loglevel warning -stats -n -i "$URL" -map 0:p:5:v -map 0:a -c copy "$OUTPUT/$GLOBALNAME.mp4"
    elif [ $RECORD = "false" ]; then
      #Play session with ffmpeg and send it to a rtmp stream server

      ffmpegcmd=$(echo 'ffmpeg -y -hide_banner -loglevel warning -re -i "'$URL'" 
                        -map 0:p:5:v -map "'$MAP'" -c:v copy -c:a aac -metadata title="'$GLOBALNAME'" -f flv "'$OUTPUT'"')


      if [ $REPLAY = "true" ];then
        ffmpegHLSargs=$(echo '-f hls -hls_time 3')
      else
        ffmpegHLSargs=$(echo '-f hls -hls_time 8 -hls_list_size 50 -hls_flags delete_segments')
      fi

      if [ $HLS == "true" ] ; then
      echo '#EXTM3U
            #EXT-X-MEDIA:BANDWIDTH=192000,TYPE=AUDIO,GROUP-ID="audio-f1",NAME="FX Audio",LANGUAGE="fx",AUTOSELECT=YES,DEFAULT=YES,URI="streams/f1tv_'$GLOBALNAME'_fx.m3u8"
            #EXT-X-STREAM-INF:BANDWIDTH=1200000,RESOLUTION=960x540,AUDIO="audio-f1"
            streams/f1tv_'$GLOBALNAME'_sd.m3u8
            #EXT-X-STREAM-INF:BANDWIDTH=3730000,RESOLUTION=1280x720,AUDIO="audio-f1"
            streams/f1tv_'$GLOBALNAME'_hd.m3u8
            #EXT-X-STREAM-INF:BANDWIDTH=6286000,RESOLUTION=1920x1080,AUDIO="audio-f1"
            streams/f1tv_'$GLOBALNAME'_fhd.m3u8
            #EXT-X-MEDIA:BANDWIDTH=192000,TYPE=AUDIO,GROUP-ID="audio-f1",NAME="Deutsch",LANGUAGE="de",AUTOSELECT=YES,DEFAULT=NO,URI="streams/f1tv_'$GLOBALNAME'_deu.m3u8"
            #EXT-X-MEDIA:BANDWIDTH=192000,TYPE=AUDIO,GROUP-ID="audio-f1",NAME="English",LANGUAGE="en",AUTOSELECT=YES,DEFAULT=NO,URI="streams/f1tv_'$GLOBALNAME'_eng.m3u8"
            ' > /srv/www/f1tv.m3u8
        ffmpegcmd+=$(echo  ' -map 0:p:5:v -map "'$MAP'" -c:v copy '$ffmpegHLSargs' "/srv/www/streams/f1tv_'$GLOBALNAME'_fhd.m3u8"
                            -map 0:p:4:v -map "'$MAP'" -c:v copy '$ffmpegHLSargs' "/srv/www/streams/f1tv_'$GLOBALNAME'_hd.m3u8"
                            -map 0:p:3:v -map "'$MAP'" -c:v copy '$ffmpegHLSargs' "/srv/www/streams/f1tv_'$GLOBALNAME'_sd.m3u8"
                            -map 0:m:language:deu? -c:a aac '$ffmpegHLSargs' "/srv/www/streams/f1tv_'$GLOBALNAME'_deu.m3u8"
                            -map 0:m:language:eng? -c:a aac '$ffmpegHLSargs' "/srv/www/streams/f1tv_'$GLOBALNAME'_eng.m3u8"
                            -map 0:m:language:fx? -c:a aac '$ffmpegHLSargs' "/srv/www/streams/f1tv_'$GLOBALNAME'_fx.m3u8"')
      fi



      echo $ffmpegcmd | bash


      if [ $HLS == "true" ] ; then
      rm /srv/www/streams/f1tv_*
      fi

      echo '#EXTM3U
      #EXT-X-VERSION:3
      #EXT-X-STREAM-INF:BANDWIDTH=415000,RESOLUTION=480x270
      streams/idle.m3u8
      ' > /srv/www/f1tv.m3u8
      
    else
      echo "error"
    fi
  fi

  #echo "---- DEBUG ----"
  #echo "AccessToken: $AccessToken"
  #echo "ContentId $ContentId"
  echo "URL: $URL"
  
  #Check status of live session every 5 minutes to avoid ip temp ban
  sleep 5m
done
