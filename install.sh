#!/bin/bash

version(){
echo " Version 0.1 - 2018 "
echo " Tested on: Raspberry Pi 3 - OSMC - Hyperion 1.03.3 "
}

usage(){

  echo "Usage:
    sudo ./install.sh
    sudo ./install.sh -i
    sudo ./install.sh [-f | --fan -c | --clock -b | --buttons -a | --assistant]
    sudo ./install.sh -h | --help
    sudo ./install.sh --version

Options:
    General options:
        -h --help           Show this screen.
        -v --version        Show version.
        -s --silent         Show less stuff during installation.
        -i --interactive    Insert installation parameters during installation.
    Custom installation options:
        -f --fan            Install fan script.
        -c --clock          Install clock effect.
        -b --buttons        Install buttons script.
        -a --assistant      Install Google Assistant script.
    ( if you use any of the custom installation options
    you will install only the scripts/effects you specify
    instead of all the scripts/effects )
"
}


echo "   ______________            __   "
echo "  /___    ____/ /____  _____/ /_  "
echo " __  / / /_  / __/ _ \/ ___/ __ \ "
echo "/ /_/ / __/ / /_/  __/ /__/ / / / "
echo "\____/_/    \__/\___/\___/_/ /_/  "
echo ""
echo "
Find out how to install both hardware and software for this project on YouTube
https://www.youtube.com/channel/UCHVYUIHCpWdqdW0ALlMS9Hg?sub_confirmation=1

Report bugs and get help on GitHub
https://github.com/JFtechOfficial/ultimate-ambilght-setup/issues
"

interactive=0
silent=0
fan=0
buttons=0
clock=0
assistant=0
startup=0

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
    -s | --silent )         silent=1
      ;;
    -i | --interactive )    interactive=1
      ;;
    -v | --version )        version
      exit 1
      ;;
    -h | --help )           usage
      exit
      ;;
    * )                     usage
      exit 1
  esac
  shift
done



# we want to be root to install
if [ $(id -u) != 0 ]; then
  echo '---> Critical Error: Please run the script as root (sudo ./install.sh) -> abort'
  exit 1
fi
#Check, if year equals 1970
DATE=$(date +"%Y")
if [ "$DATE" -le "2017" ]; then
  echo "---> Critical Error: Please update your systemtime (Year of your system: ${DATE}) -> abort"
  exit 1
fi
output=""
if [ $silent -ne 0 ]; then
  output="1>/dev/null"
fi
default_install=$((fan+buttons+assistant+clock))
if [ $default_install -eq 0 ]; then
  fan=1
  buttons=1
  clock=1
  assistant=1
fi
startup=$((fan+buttons+assistant))
gpio=$((fan+buttons))

re='^-?[0-9]+([.][0-9]+)?$'
rei='^[0-9]+$'

echo "Starting..."
# Find out if we are on OpenElec (Rasplex) / OSMC / Raspbian
OS_OPENELEC=`grep -m1 -c 'OpenELEC\|RasPlex\|LibreELEC\|OpenPHT\|PlexMediaPlayer' /etc/issue`
OS_LIBREELEC=`grep -m1 -c LibreELEC /etc/issue`
OS_RASPLEX=`grep -m1 -c RasPlex /etc/issue`
OS_OSMC=`grep -m1 -c OSMC /etc/issue`
OS_RASPBIAN=`grep -m1 -c 'Raspbian\|RetroPie' /etc/issue`

# check which should use
USE_SYSTEMD=`grep -m1 -c systemd /proc/1/comm`
USE_INITCTL=`which /sbin/initctl | wc -l`
USE_SERVICE=`which /usr/sbin/service | wc -l`


if [ $OS_OPENELEC -ne 1 ]; then

  echo -n "Updating System..."
  sudo apt-get update -y
  ##sudo apt-get upgrade -y
  ##sudo apt-get dist-upgrade -y
  sudo apt-get autoremove -y
  sudo apt-get autoclean -y
fi
##-qq  1>/dev/null
#Install dependencies and setup preperation
echo -n "Downloading and installing Python..."
sudo apt-get install -y build-essential
sudo apt-get install -y python
sudo apt-get install -y python-dev
sudo apt install -y python-pip
##curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
##python get-pip.py
if [ $gpio -ne 0 ]; then
  if [ $interactive -ne 0 ] then
    read OWMkey
  fi
  echo -n "Downloading Rpi.GPIO..."
  sudo wget https://pypi.python.org/packages/source/R/RPi.GPIO/RPi.GPIO-0.6.2.tar.gz
  echo -n "installing Rpi.GPIO..."
  sudo tar -xf RPi.GPIO-0.6.2.tar.gz --strip-components 1
  sudo python setup.py install
  sudo rm -rf RPi.GPIO-0.6.2.tar.gz

fi
if [ $clock -ne 0 ]; then
  echo "Stop Hyperion, if necessary"
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
  # Clock effect for Hyperion
  echo -n "Installing pyowm..."
  sudo pip install pyowm
  
  ######################################
    if [ $interactive -ne 0 ] then
    echo "
Enter your OpenWeatherMap API key.
Leave empty if you don't want to modify the default value.
You can get a new API key here: https://openweathermap.org/appid
    "
    read -p "OpenWeatherMap API key: " OWMkey
    
    echo "
Enter your own latitude and longitude.
Leave empty if you don't want to modify the default value.
You can find your coordinates here: https://www.whataremycoordinates.com/
    "
    while read -p "Latitude: " lat; do
      if ! [[ $lat  =~ $re ]]; then
       echo "Latitude must be a decimal number"
       else break
      fi
    done
    while read -p "Longitude: " lon; do
      if ! [[ $lon  =~ $re ]]; then
       echo "Longitude must be a decimal number"
       else break
      fi
    done
    
    echo "
Enter your LED stip offset number.
Leave empty if you don't want to modify the default value.
    "
    while read -p "Offset: " ofs; do
      if ! [[ $lon  =~ $rei ]]; then
       echo "Offset must be an integer number"
       else break
      fi
    done

        echo "
Enter the direction of your LED stip.
0 -> clockwise, 1 -> counterclockwise.
Leave empty if you don't want to modify the default value.
    "
    while read -p "Direction: " direc; do
      if ! [[ $lon  =~ [0-1]]]; then
       echo "Direction must be an 0 or 1"
       else break
      fi
    done
    
#use jq to write de values of $OWMkey $lat $lon $ofs $direc if they are not empty
    if [-z $Cconfig ]; then
    echo "use jq"
    fi
  fi
  
  ######################################
  echo -n "installing clock effect..."
  sudo mv Hyperion\ effects/clock.py /usr/share/hyperion/effects/
  sudo mv Hyperion\ effects/clock.json /usr/share/hyperion/effects/
  echo "Starting Hyperion..."
  if [ $OS_OPENELEC -eq 1 ]; then
    /storage/.config/autostart.sh > /dev/null 2>&1 &
  elif [ $USE_SYSTEMD -eq 1 ]; then
    systemctl start hyperion
  elif [ $USE_INITCTL -eq 1 ]; then
    /sbin/initctl start hyperion
  elif [ $USE_SERVICE -eq 1 ]; then
    /usr/sbin/service hyperion start
  fi
fi
if [ $startup -ne 0 ]; then
  sudo apt install -y curl
  sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  echo -n "installing nodejs and npm..."
  sudo apt-get install -y nodejs
  sudo apt-get install -y npm
  echo -n "installing forever-service..."
  sudo npm install -g forever
  sudo npm install -g forever-service
fi
if [ $assistant -ne 0 ]; then
  ehco -n "installing some other usefull modules..."
  sudo npm install -g hyperion-client
  sudo -H pip install --upgrade youtube-dl
  sudo npm install -g playonkodi
  echo -n "installing Google Assisant client script..."
  sudo forever-service install assistant-service --script scripts/client.js
  sudo service assistant-service start
fi
if [ $fan -ne 0 ]; then
  echo -n "installing fan script..."
  sudo forever-service install fan-service -s scripts/fan.py -f " -c python"
  sudo service fan-service start
fi
if [ $buttons -ne 0 ]; then
  echo -n "installing buttons script..."
  sudo forever-service install buttons-service -s scripts/buttons.py -f " -c python"
  sudo service buttons-service start
fi
##sudo apt-get install cron -y
##if [ $? -eq 0 ]; then
##    echo "OK"
##else
##    echo "ERROR"
##    exit 1
##fi

# cleanup -> TO-DO
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
