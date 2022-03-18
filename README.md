# <b>F1TV -> RTMP</b>
 Play live content from F1TV with any RTMP Player

<br>

## <b>Installation-Docker</b>

If you want to get a rtmp stream of live events use: \
`docker run -d -p 1935:1935 -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" -e LANGUAGE=<LANG-CODE> -e LIVE=true -e RECORD=false htobi02/f1tv:latest`

If you want to get a rtmp stream of the most recent event use: \
`docker run -d -p 1935:1935 -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" -e LANGUAGE=<LANG-CODE> -e LIVE=false -e RECORD=false htobi02/f1tv:latest`

If you want to record all upcoming live events use (NOTE: This disables the rtmp stream!): \
`docker run -d -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" -e LANGUAGE=<LANG-CODE> -e LIVE=true -e RECORD=true -v </HOST/PATH/TO/SAVE/RECORDS>:/record htobi02/f1tv:latest`

If you want to record the most recent event use (NOTE: This disables the rtmp stream!): \
`docker run -d -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" -e LANGUAGE=<LANG-CODE> -e LIVE=false -e RECORD=true -v </HOST/PATH/TO/SAVE/RECORDS>:/record htobi02/f1tv:latest`


## <b>Docker-compose</b>
.env:
```
TAG=latest
F1TV_EMAIL=formula1@example.com
F1TV_PASSWORD=SuperSecretPassword
LANGUAGE=eng
LIVE=true
RECORD=false
OUTPUT=rtmp://127.0.0.1:1935/live/f1tv
```
<br>

## <b>Configuration</b>
Variable|Description|Example|Default
:----|:----|:----|:----
F1TV_EMAIL|Type in your F1TV E-Mail Address|formula1@example.com|./.
F1TV_PASSWORD|Type in your F1TV Password|SuperSecretPassword|./.
LANGUAGE|in which language do you prefer watching F1|fx|eng
LIVE|do you want to only see live events|true|true
RECORD|do you want to record <br>*(**IMPORTANT**: This disables the rtmp stream)*|false|false
OUTPUT|where do you want to output the stream|rtmp://mycoolvideoserver/live/f1tv|rtmp://127.0.0.1:1935/live/f1tv

<br>

Available Languages|Description
:----|:----
deu|*German Audio Track*
fra|*French Audio Track*
spa|*Spanish Audio Track*
por|*Portugese Audio Track*
nld|*Netherlands Audio Track*
eng|*English Audio Track*
fx|*FX Audio Track (**No Commentators**)*

## ToDo
[x] Add other languages (german and english) \
[x] Remove audio/video desync \
[x] Add Healthcheck \
[ ] Use Alpine Image \
[ ] Add HLS \
[ ] Add Recording Feature
