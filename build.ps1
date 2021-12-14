Set-Location $PSScriptRoot
docker system prune -a -f

docker build -t htobi02/f1tv:latest -f Dockerfile .

docker push htobi02/f1tv:latest

docker system prune -a -f