FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; apt-get install -y ffmpeg vlc cron; \
	touch /etc/crontab /etc/cron.*/*; \
	touch /var/log/cron.log; \
	rm -rf /var/lib/apt/lists/*

COPY src/* /usr/local/timelapse/

RUN chmod +x /usr/local/timelapse/*.sh

#Fix cron a little :)
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so/' /etc/pam.d/cron
RUN sed -i "s/IMAGE_CRON_PATTERN/$IMAGE_CRON_PATTERN/g" /usr/local/timelapse/timelapse.cron
RUN sed -i "s/MOVIE_CRON_PATTERN/$MOVIE_CRON_PATTERN/g" /usr/local/timelapse/timelapse.cron

VOLUME /timelapse_data/

ENV CAMERA_NAME=${CAMERA_NAME}
RUN export CAMERA_NAME=${CAMERA_NAME}
#ENV CAMERA_RTSP

CMD ["/bin/bash", "/usr/local/timelapse/init.sh"]
