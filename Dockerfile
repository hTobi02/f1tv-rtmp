FROM alqutami/rtmp-hls:latest

RUN DEBIAN_FRONTEND="noninteractive" apt update && apt-get -y install tzdata
RUN apt update && \
	apt install python3 python3-pip curl -y

RUN python3 -m pip install --upgrade pip && \
	pip install streamlink

COPY f1tv.py /usr/local/lib/python3.9/dist-packages/streamlink/plugins/

RUN apt install -y jq

WORKDIR /app
COPY ./app/ .
RUN rm -R /usr/local/nginx/html/players
COPY ./player.html /usr/local/nginx/html
RUN rm /etc/nginx/nginx.conf
COPY ./nginx_hls.conf /etc/nginx/nginx.conf
EXPOSE 1935
CMD bash /app/entrypoint-last.sh