sleep 15
while [[ $(ps | grep "ffmpeg" | wc -l) -gt 1 ]]; do
    GLOBALNAME=$(curl -s --request GET --url https://f1tv.formula1.com/2.0/R/DEU/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2 | jq -r '[.resultObj.containers[].retrieveItems.resultObj.containers[].metadata | select(.contentType == "VIDEO") | select((.titleBrief == "Rennen") or (.titleBrief == "Qualifying") or (.titleBrief == "Sprintrennen") or (.titleBrief | startswith("Training")))][0].emfAttributes.Global_Title')
    if [[ "$1" != "$GLOBALNAME" ]]; then
        $(ps axf | grep ffmpeg | grep -v grep | awk '{print "kill -9 " $1}')
        exit
    fi
    sleep 1m
done