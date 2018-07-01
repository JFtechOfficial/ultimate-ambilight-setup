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
    sudo apt-get install -y build-essential
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    sudo apt-get install -y python
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR"
        exit 1
    fi
    sudo apt-get install -y python-dev
    sudo apt install -y python-pip
    ##curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    ##python get-pip.py
}


ambilight_scripts_install(){
    echo -n "Downloading..."
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
    fi
    sudo mv Hyperion\ effects/clock.py /usr/share/hyperion/effects/
    sudo mv Hyperion\ effects/clock.json /usr/share/hyperion/effects/
    sudo apt install -y curl
    sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo apt-get install -y npm
    sudo npm install -g forever
    sudo npm install -g forever-service
    sudo npm install -g hyperion-client
    sudo -H pip install --upgrade youtube-dl
    sudo npm install -g playonkodi
    ##sudo apt-get install cron -y
    ##if [ $? -eq 0 ]; then
    ##    echo "OK"
    ##else
    ##    echo "ERROR"
    ##    exit 1
    ##fi
}
echo "   ______________            __   "
echo "  /___    ____/ /____  _____/ /_  "
echo " __  / / /_  / __/ _ \/ ___/ __ \ "
echo "/ /_/ / __/ / /_/  __/ /__/ / / / "
echo "\____/_/    \__/\___/\___/_/ /_/  "

echo "Starting..."
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
