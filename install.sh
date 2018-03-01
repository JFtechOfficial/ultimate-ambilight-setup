#!/bin/bash

prerequisites() {
    # we want to be root to install
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit 1
    fi
}

system_update(){
    echo -n "Updating System..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
}

python_install(){
    echo -n "Downloading, installing Python..."
    sudo apt-get install build-essential -y
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    sudo apt-get install Python Python-dev Python-pip -y
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
}

ambilight_scripts_install(){
    echo -n "Downloading, installing scripts..."
    mkdir -p /home/osmc/Development
    wget https://pypi.python.org/packages/source/R/RPi.GPIO/RPi.GPIO-0.6.2.tar.gz -P /home/osmc/Development
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    tar -xf /home/osmc/Development/RPi.GPIO-0.6.2.tar.gz
    sudo python /home/osmc/Development/RPi.GPIO-0.6.2/setup.py install
    sudo rm -rf /home/osmc/Development/RPi.GPIO-0.*
    # Clock effect for Hyperion
    sudo pip install pyowm
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    wget clock.py-raw -P /home/osmc/Development
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    # Clock effect config
    wget clock.json-raw -P /home/osmc/Development
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    # Fan
    wget run-fan.py -P /home/osmc/Development
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    # Buttons
    wget buttons.py -P /home/osmc/Development
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    sudo apt-get install cron -y
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
}

echo -n "Starting..."
prerequisites
system_update
python_install
ambilight_scripts_install
echo
echo -n "REBOOT NOW? [y/N]"
read
if [[ "$REPLY" =~ ^(yes|y|Y)$ ]]; then
    echo "Reboot started..."
    reboot
else
    echo
    echo "Done"
fi
