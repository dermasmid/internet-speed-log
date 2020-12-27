# speed-log

I made this to run on my raspberry pi which is hooked up to my local network, in order to monitor my internet speed.

## Installation

``` bash
git clone https://github.com/dermasmid/internet-speed-log && cd internet-speed-log && sudo chmod +x setup.sh
./setup.sh
```

## Usage

The file with the logs will be: `/var/log/speed_log.log`

Tail the output: `sudo journalctl -u speed_log -f`

See the service status: `sudo systemctl status speed_log.service`
