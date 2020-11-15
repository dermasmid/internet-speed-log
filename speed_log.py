#! /usr/bin/python3
import subprocess
import time
from datetime import datetime




def main():
    while True:
        data = subprocess.run(["speedtest"], capture_output= True).stdout.decode()
        lines = data.split('\n')
        hosted_by, ping = lines[4].split('Hosted by ')[1].split(':')
        ping = ping.split(' ms')[0].strip()
        download = lines[6].split('Download: ')[1]
        upload = lines[8].split('Upload: ')[1]
        print(f'{datetime.now()} - hosted_by: {hosted_by} ping: {ping} download: {download} up: {upload}')
        time.sleep(4 * 60)






if __name__ == "__main__":
    main()