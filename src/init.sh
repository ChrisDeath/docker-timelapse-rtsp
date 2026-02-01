#!/bin/bash

if [ -z "${CAMERA_NAME}" ] ; then
	echo "Camera name not set, exiting..."
	sleep 30
	exit 1
fi

TIMELAPSE_DATA="/timelapse_data/"
CAMERA_HOME="${TIMELAPSE_DATA}/${CAMERA_NAME}"
RAW_IMAGE_DIR="${CAMERA_HOME}/raw"
PROCESSED_VID_DIR="${TIMELAPSE_DATA}/done"

#if a cfg file exists then overwrite env settings
if [ -n "${CAMERA_HOME}" ] && [ -f "${CAMERA_HOME}/timelapse.cfg" ] ; then
  . ${CAMERA_HOME}/timelapse.cfg
fi

if [ -z "${CAMERA_RTSP}" ] ; then
	echo "Camera RTSP Stream not set, exiting..."
	sleep 30
	exit 1
fi

echo "CAMERA_NAME=\"${CAMERA_NAME}\"" >> /settings.cfg
echo "TIMELAPSE_DATA=\"${TIMELAPSE_DATA}\"" >> /settings.cfg
echo "CAMERA_HOME=\"${CAMERA_HOME}\"" >> /settings.cfg
echo "RAW_IMAGE_DIR=\"${RAW_IMAGE_DIR}\"" >> /settings.cfg
echo "PROCESSED_VID_DIR=\"${PROCESSED_VID_DIR}\"" >> /settings.cfg
echo "CAMERA_RTSP=\"${CAMERA_RTSP}\"" >> /settings.cfg
echo "CAMERA_RTSP_FRAMERATE=\"${CAMERA_RTSP_FRAMERATE}\"" >> /settings.cfg
echo "OVERLAY_TXT_FILE=\"${OVERLAY_TXT_FILE}\"" >> /settings.cfg
echo "OVERLAY_FONT_FILE=\"${OVERLAY_FONT_FILE}\"" >> /settings.cfg
echo "DAYS_TO_KEEP=\"${DAYS_TO_KEEP}\"" >> /settings.cfg

echo "Using following settings:"
cat /settings.cfg

sed -i "s/IMAGE_CRON_PATTERN/$IMAGE_CRON_PATTERN/g" /usr/local/timelapse/timelapse.cron
sed -i "s/MOVIE_CRON_PATTERN/$MOVIE_CRON_PATTERN/g" /usr/local/timelapse/timelapse.cron
echo "Using following Cron config:"
cat /usr/local/timelapse/timelapse.cron

crontab /usr/local/timelapse/timelapse.cron
cron -f

echo "Finished setup!"