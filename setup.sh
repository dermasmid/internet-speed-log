#! /bin/sh


pip3 install -r requirements.txt
sudo cp etc/systemd/speed_log.service /etc/systemd/system/
sudo cp etc/rsyslog.d/speed_log.conf /etc/rsyslog.d/
sudo systemctl daemon-reload
sudo systemctl restart rsyslog.service
sudo systemctl start speed_log.service
sudo systemctl enable speed_log.service