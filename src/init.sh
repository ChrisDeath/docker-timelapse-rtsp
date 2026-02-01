#!/bin/bash

if [ -z "${CAMERA_NAME}" ] ; then
	echo "Camera name not set, exiting..."
	sleep 30
	exit 1
fi

export TIMELAPSE_DATA="/timelapse_data/"
export CAMERA_HOME="${TIMELAPSE_DATA}/${CAMERA_NAME}"
export RAW_IMAGE_DIR="${CAMERA_HOME}/raw"
export PROCESSED_VID_DIR="${TIMELAPSE_DATA}/done"

#Create folder structure if not present
if [ -n "${RAW_IMAGE_DIR}" ] && [ ! -d "${RAW_IMAGE_DIR}" ] ; then
	#Remove "" from name string
	#CAMERA_NAME=`sed -e 's/^"//' -e 's/"$//' <<<"${CAMERA_NAME}"`
	mkdir -p ${RAW_IMAGE_DIR}
fi

#if a cfg file exists then overwrite env settings
if [ -n "${CAMERA_HOME}" ] && [ -f "${CAMERA_HOME}/timelapse.cfg" ] ; then
  . ${CAMERA_HOME}/timelapse.cfg
fi

if [ -z "${CAMERA_RTSP}" ] ; then
	echo "Camera RTSP Stream not set, exiting..."
	sleep 30
	exit 1
fi

echo "Using ${CAMERA_RTSP} for ${CAMERA_NAME}"

echo "${CAMERA_NAME}" > /camera.name

sed -i "s/IMAGE_CRON_PATTERN/$IMAGE_CRON_PATTERN/g" /usr/local/timelapse/timelapse.cron
sed -i "s/MOVIE_CRON_PATTERN/$MOVIE_CRON_PATTERN/g" /usr/local/timelapse/timelapse.cron
echo "Using following Cron config:"
cat /usr/local/timelapse/timelapse.cron

crontab /usr/local/timelapse/timelapse.cron
cron -f
#service cron start


#Hang around forever
#tail -f /var/log/cron.log

echo "Finished setup!"