# F1TV -> RTMP
 Play live content from F1TV with any RTMP Player

## Quick Start Guide:

`docker run --rm -it -p 1935:1935 -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" htobi02/f1tv`

If your want to record every Session use: \
`docker run --rm -it -p 1935:1935 -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" -v /host/path/for/saving/sessions/:/record -e RECORD="$true" htobi02/f1tv`

