. /settings.cfg

if [ ! -d "${RAW_IMAGE_DIR}" ] ; then
	mkdir -p ${RAW_IMAGE_DIR}
fi

if [ ! -z "${OVERLAY_TXT_FILE}" ] && [ -f "${OVERLAY_FONT_FILE}" ] ; then
	for SEC in 00;
	do 
		ffmpeg -y -r ${CAMERA_RTSP_FRAMERATE} -i ${CAMERA_RTSP} \
		-vf drawtext="textfile=${CAMERA_HOME}/${OVERLAY_TXT_FILE} \
		:fontfile=${CAMERA_HOME}/${OVERLAY_FONT_FILE} \
		:box=1 \
		:x=1:y=1 \
		:fontsize=32 \
		:fontcolor=white \
		:boxborderw=1 \
		:boxcolor=black@0.2 \
		:reload=1" \
		-rtsp_transport udp -r ${CAMERA_RTSP_FRAMERATE} -an  -frames:v 1 -strftime 1 \
		"${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
	done
	else
	for SEC in 00;
	do 
		ffmpeg -rtsp_transport udp -timeout 3000 -y -r ${CAMERA_RTSP_FRAMERATE} -i ${CAMERA_RTSP} -r ${CAMERA_RTSP_FRAMERATE} -an -frames:v 1 -strftime 1 "${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
	done
fi
