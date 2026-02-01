#!/bin/bash

if [ -z "${CAMERA_NAME}" ] ; then
	echo "Camera name not set, exiting..."
	sleep 30
	exit 1
fi

#Create folder structure if not present
if [ -n "${CAMERA_NAME}" ] && [ ! -f "/timelapse_data/${CAMERA_NAME}/timelapse.cfg" ] ; then
	#Remove "" from name string
	CAMERA_NAME=`sed -e 's/^"//' -e 's/"$//' <<<"${CAMERA_NAME}"`
	mkdir -p /timelapse_data/${CAMERA_NAME}/raw/
	cp /usr/local/timelapse/timelapse.cfg.example /timelapse_data/${CAMERA_NAME}/timelapse.cfg
fi

. /timelapse_data/${CAMERA_NAME}/timelapse.cfg


if [ -z "${CAMERA_RTSP}" ] ; then
	echo "Camera RTSP Stream not set, exiting..."
	sleep 30
	exit 1
fi

echo "Using ${CAMERA_RTSP} for ${CAMERA_NAME}"

echo "${CAMERA_NAME}" > /camera.name

echo "Using following Cron config:"
cat /usr/local/timelapse/timelapse.cron

crontab /usr/local/timelapse/timelapse.cron
cron -f
#service cron start


#Hang around forever
#tail -f /var/log/cron.log

echo "Finished setup!"