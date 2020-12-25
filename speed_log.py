#!/usr/bin/python3
import subprocess
import time
import json
import os

SLEEP_MINS = int(os.getenv("SLEEP_MINS"))

def main():
    while True:
        data = subprocess.run(['python3', '-m', 'speedtest', '--json'], capture_output= True).stdout.decode()
        if data:
            json_data = json.loads(data)
            hosted_by = json_data['server']['sponsor']
            ping = json_data['ping']
            download = str(json_data['download'] / 8e+6)[:6]
            upload = str(json_data['upload'] / 8e+6)[:6]
        else:
            hosted_by, ping, download, upload = None, 0, 0, 0
        print(f'hosted_by: {hosted_by}, ping: {ping}, down: {download} MB/s, up: {upload} MB/s')
        time.sleep(SLEEP_MINS * 60)






if __name__ == "__main__":
    main()