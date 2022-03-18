#!/bin/bash
if [ "$OUTPUT" != "rtmp://127.0.0.1:1935/live/f1tv" ] || [ -z $OUTPUT ] || [ "$RECORD" == "false" ]; then
  nginx
fi
bash /app/f1tv.sh