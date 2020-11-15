#! /bin/sh


pip3 install -r requirements.txt
sudo cp etc/systemd/speed_log.service /etc/systemd/system/
sudo cp etc/rsyslog.d/speed_log.conf /etc/rsyslog.d/
sudo cp speed_log.py /usr/bin/
sudo chmod +x /usr/bin/speed_log.py
sudo systemctl daemon-reload
sudo systemctl restart rsyslog.service
sudo systemctl start speed_log.service


# Uncomment if you want to enable
# sudo systemctl enable speed_log.service