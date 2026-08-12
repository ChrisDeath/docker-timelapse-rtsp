. /settings.cfg

if [ ! -d "${RAW_IMAGE_DIR}" ] ; then
	mkdir -p ${RAW_IMAGE_DIR}
fi

# Default to 2 screenshots per minute if not set
IMAGESHOT_COUNT_MINUTE=${IMAGESHOT_COUNT_MINUTE:-2}
INTERVAL=$((60 / IMAGESHOT_COUNT_MINUTE))

if [ ! -z "${OVERLAY_TXT_FILE}" ] && [ -f "${OVERLAY_FONT_FILE}" ] ; then
	for i in $(seq 0 $((IMAGESHOT_COUNT_MINUTE - 1)));
	do 
		SEC=$(printf "%02d" $((i * INTERVAL)))
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
		[ $i -lt $((IMAGESHOT_COUNT_MINUTE - 1)) ] && sleep $((INTERVAL - 1))
	done
	else
	for i in $(seq 0 $((IMAGESHOT_COUNT_MINUTE - 1)));
	do 
		SEC=$(printf "%02d" $((i * INTERVAL)))
		ffmpeg -y -i ${CAMERA_RTSP} -rtsp_transport udp -r 25 -pix_fmt yuvj422p -vf scale=${IMAGE_RESOLUTION}:-2,setsar=1:1 -an -frames:v 1 -strftime 1 "${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
		[ $i -lt $((IMAGESHOT_COUNT_MINUTE - 1)) ] && sleep $((INTERVAL - 1))
	done
fi
