. /settings.cfg

if [ ! -d "${RAW_IMAGE_DIR}" ] ; then
	mkdir -p ${RAW_IMAGE_DIR}
fi

if [ ! -z "${OVERLAY_TXT_FILE}" ] && [ -f "${OVERLAY_FONT_FILE}" ] ; then
	for SEC in 00 15 30 45;
	do 
		ffmpeg -y -i ${CAMERA_RTSP} \
		-vf drawtext="textfile=${CAMERA_HOME}/${OVERLAY_TXT_FILE} \
		:fontfile=${CAMERA_HOME}/${OVERLAY_FONT_FILE} \
		:box=1 \
		:x=1:y=1 \
		:fontsize=32 \
		:fontcolor=white \
		:boxborderw=1 \
		:boxcolor=black@0.2 \
		:reload=1" \
		-rtsp_transport udp -r 25 -pix_fmt yuvj422p -an -frames:v 1 -strftime 1 \
		"${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
		sleep 14
	done
	else
	for SEC in 00 15 30 45;
	do 
		ffmpeg -y -i ${CAMERA_RTSP} -rtsp_transport udp -r 25 -pix_fmt yuvj422p -vf scale=${IMAGE_RESOLUTION}:-2,setsar=1:1 -an -frames:v 1 -strftime 1 "${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
		sleep 14
	done
fi
