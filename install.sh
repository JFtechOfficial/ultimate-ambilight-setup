#!/bin/bash

prerequisites() {
    # we want to be root to install
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit 1
    fi
    interactive=
    fan=
    buttons=
    clock=
    assistant=
    
    while [ "$1" != "" ]; do
        case $1 in
            -f | --fan )            fan=1
                                    ;;
            -b | --buttons )        buttons=1
                                    ;;
            -c | --clock )          clock=1
                                    ;;
            -a | --assistant )      assistant=1
                                    ;;
            -v | --verbose )        verbose=1
                                    ;;
            -i | --interactive )    interactive=1
                                    ;;
            -h | --help )           usage
                                    exit
                                    ;;
            * )                     usage
                                exit 1
    esac
    shift
done
echo $fan

}

system_update(){
    echo -n "Updating System..."
    sudo apt-get update -y
    ##sudo apt-get upgrade -y
    ##sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
    echo '---> Stop Hyperion, if necessary'
if [ $OS_OPENELEC -eq 1 ]; then
    killall hyperiond 2>/dev/null
elif [ $USE_SYSTEMD -eq 1 ]; then
	service hyperion stop 2>/dev/null
	#many people installed with the official script and this just uses service, if both registered -> dead
	/usr/sbin/service hyperion stop 2>/dev/null
elif [ $USE_INITCTL -eq 1 ]; then
	/sbin/initctl stop hyperion 2>/dev/null
elif [ $USE_SERVICE -eq 1 ]; then
	/usr/sbin/service hyperion stop 2>/dev/null
fi



    
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
    sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo apt-get install -y npm
    sudo npm install -g forever
    sudo npm install -g forever-service
    sudo npm install -g hyperion-client
    sudo -H pip install --upgrade youtube-dl
    sudo npm install -g playonkodi
    sudo forever-service install assistant-service --script scripts/client.js 
    sudo forever-service install fan-service -s scripts/fan.py -f " -c python"
    sudo forever-service install buttons-service -s scripts/buttons.py -f " -c python"
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
#Install dependencies for Hyperion and setup preperation
if [ $OS_OPENELEC -ne 1 ]; then
	system_update
fi
python_install
ambilight_scripts_install
echo '---> Starting Hyperion'
if [ $OS_OPENELEC -eq 1 ]; then
	/storage/.config/autostart.sh > /dev/null 2>&1 &
elif [ $USE_SYSTEMD -eq 1 ]; then
	systemctl start hyperion
elif [ $USE_INITCTL -eq 1 ]; then
	/sbin/initctl start hyperion
elif [ $USE_SERVICE -eq 1 ]; then
	/usr/sbin/service hyperion start
fi
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
