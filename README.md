# F1TV -> RTMP
 Play live content from F1TV with any RTMP Player

## Docker Images
`latest` - same like `de-live` \
`de-last` - show always the last session in german \
`de-live` - only show live sessions in german \
`en-last` - show always the last session in english \
`en-live` - only show live sessions in english 

## Installation

`docker run --rm -it -p 1935:1935 -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" htobi02/f1tv:<image-tag>`

~~If your want to record every Session use: ~~\
~~`docker run --rm -it -p 1935:1935 -e F1TV_EMAIL="<YOUR F1TV EMAIL>" -e F1TV_PASSWORD="<YOUR F1TV PASSWORD>" -v /host/path/for/saving/sessions/:/record -e RECORD="$true" htobi02/f1tv`~~

## ToDo
[x] Add other languages (german and english) \
[ ] Add Recording Feature