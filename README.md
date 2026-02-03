# docker-timelapse-rtsp
Set of scripts run in a docker to capture RTSP stream & create a timelapse video.

It is based on https://github.com/inventari/docker-timelapse but removed weahter info and youtube upload.

**REMARK:** It is strongly recommended to have GPU acceleration in place as video generation can be time-consuming. Current settings are set to high compatibility (CPU). 

# Usage

Edit .env to fit your file structure

Edit docker-compose.yml to fit your local setup.

docker-compose.yml example is for 2 cameras, with descriptive names.

```code
docker-compose build

#This creates the individual `.env:DOCKERCONFDIR/docker-compose.yml:CAMERA_NAME/` folder structure.
docker-compose up -d
docker-compose down
```
edit the .env:DOCKERCONFDIR/docker-compose.yml:CAMERA_NAME/timelapse.cfg to fit your config.

```code
docker compose up -d
```
# Debugging
ffmpeg cron run outputs to /var/log/cron.log for debugging if needed.

