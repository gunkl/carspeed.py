HOST?=pi@127.0.0.1
TARGET_PATH?=speed-camera

install:
	apt-get install python3-picamera python3-docopt python3-opencv python3-scipy python3-numpy imagemagick python3-yaml
	cp ./speed-camera.service /etc/systemd/system/speed-camera.service
	systemctl daemon-reload
	systemctl enable speed-camera.service
	systemctl start speed-camera.service
	sleep 1
	systemctl status speed-camera.service

restart:
	systemctl restart speed-camera.service

stop:
	systemctl stop speed-camera.service

preview:
	python3 speed-camera.py preview --config config.yaml

sync:
	rsync --exclude '.*' --exclude 'logs' -azr --progress . ${HOST}:${TARGET_PATH}

sync-logs:
	rsync  -azr --progress ${HOST}:${TARGET_PATH}/logs/* ./logs/

clean:
	rm -rf logs
	rm -rf *.jpg

tail:
	journalctl -f -u speed-camera.service

connect:
	ssh -t ${HOST} "cd ${TARGET_PATH}; bash"