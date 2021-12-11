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

## ToDo
[x] Add other languages (german and english) \
[x] Remove audio/video desync \
[x] Add Healthcheck \
[ ] Use Alpine Image \
[ ] Add HLS \
[ ] Add Recording Feature