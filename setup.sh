#!/bin/sh

# root is required to modify systemd. Only run as root
IS_ROOT=$(whoami)
if [ "$IS_ROOT" != root ]; then
    echo "Please run as root."
    exit 1
fi

# Check if pip3 is installed
PIP_CMD=$(command -v pip3)

# If pip is not installed suggest to install and exit.
if [ -z "$PIP_CMD" ]; then
    echo "pip3 not installed. Please install and re-run script"
    exit 1
fi

# Set additional flags for installation options
while getopts "hd:s:e" option; do 
    case "$option" in
        h) echo "The following options are available:
           -d specify taget installation. (default is /usr/local/bin)
           -s specify syslog application
           -e enable and start service after installation
           -h this help menu"
           exit 0
        ;;
        d) INSTALL_DIR=${OPTARG}
        ;;
        s) SYSLOG_CMD=${OPTARG}
        ;;
        e) ENABLED=1
        ;;
        *) echo "invalid option"
            exit 0
        ;;
    esac
done

# If -d was not specified, install in /usr/local/bin
if [ -z "$INSTALL_DIR" ]; then
    echo "No install directory specified, defaulting to /usr/local/bin"
    INSTALL_DIR=/usr/local/bin;
fi

# Create INSTALL_DIR if it does not exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "$INSTALL_DIR does not exist. creating"
    mkdir -p "$INSTALL_DIR"
fi

# If -s flag was not set, automatically check what syslog is being used.
RSYSLOG_PID=$(pgrep rsyslog)
SYSLOG_NG=$(pgrep syslog-ng)

if [ -z "$SYSLOG_CMD" ]; then
    if [ -z "$RSYSLOG_PID" ]; then
    #echo "rsyslog is not running. Other syslog applications have not yet been implimented"
    #exit 1;
    SYSLOG_CMD=syslog-ng;
    SYSLOG_CONF=etc/syslog-ng/conf.d/0ispeed.conf
    else
        if [ -z "$SYSLOG_NG" ]; then
        SYSLOG_CMD=rsyslog;
        SYSLOG_CONF=etc/rsyslog.d/speed_log.conf;
        fi
    fi
fi

# Install requirements
$PIP_CMD install -r requirements.txt

# Generate unit file based on variables set.
echo "Generating systemd unit file"
cat << EOF > /etc/systemd/system/speed_log.service
[Unit]
Description=Internet speed logging

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
Environment=PYTHONUNBUFFERED=1
ExecStart=$INSTALL_DIR/speed_log.py
SyslogIdentifier=speed_log
SyslogFacility=local7
SyslogLevel=info
EOF

# Configure syslog
echo "configuring syslog"
cp $SYSLOG_CONF /$SYSLOG_CONF

# Install speed_log
echo "Installing speed_log to $INSTALL_DIR"
cp speed_log.py $INSTALL_DIR
chmod +x $INSTALL_DIR/speed_log.py

# reload systemd and syslog
echo "reloading systemd"
systemctl daemon-reload
systemctl restart $SYSLOG_CMD.service
systemctl restart systemd-journald


# Enable and start if -e flag was set. 
if [ "$ENABLED" = 1 ]; then
    echo "Enabling and starting service"
    systemctl enable speed_log.service
    systemctl start speed_log.service
fi
