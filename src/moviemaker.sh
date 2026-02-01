. /settings.cfg

date="$(date "+%Y-%m-%d" -d "1 day ago")"

mkdir -p ${RAW_IMAGE_DIR}/${date}
mv ${RAW_IMAGE_DIR}/${date}_* ${RAW_IMAGE_DIR}/${date}/

ffmpeg -f image2 -i ${RAW_IMAGE_DIR}/${date}/%*.jpg -vcodec libx264 -r 60 -strftime 1 ${PROCESSED_VID_DIR}/"${date}-${CAMERA_NAME}".mp4 -y

#Clean out old data
find ${RAW_IMAGE_DIR} -type d -ctime +${DAYS_TO_KEEP} -exec rm -rf '{}' \;

