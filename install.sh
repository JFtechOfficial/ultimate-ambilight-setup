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
    ##sudo apt-get upgrade -y
    ##sudo apt-get dist-upgrade -y
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
    sudo apt-get install python -y
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    sudo apt-get install Python-dev
    sudo apt install python-pip
    ##curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    ##python get-pip.py
}


ambilight_scripts_install(){
    echo -n "Downloading, installing scripts..."
    wget https://pypi.python.org/packages/source/R/RPi.GPIO/RPi.GPIO-0.6.2.tar.gz
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    tar -xf RPi.GPIO-0.6.2.tar.gz --strip-components 1
    sudo python setup.py install
    ##sudo rm -rf RPi.GPIO-0.*
    # Clock effect for Hyperion
    sudo pip install pyowm
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1

    ##sudo apt-get install cron -y
    ##if [ $? -eq 0 ]; then
    ##    echo "OK"
    ##else
    ##    echo "ERROR"
    ##    exit 1
    fi
}
echo "   ______________            __  "
echo "  /___    ____/ /____  _____/ /_ "
echo " __  / / /_  / __/ _ \/ ___/ __ \"
echo "/ /_/ / __/ / /_/  __/ /__/ / / /"
echo "\____/_/    \__/\___/\___/_/ /_/ "

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
