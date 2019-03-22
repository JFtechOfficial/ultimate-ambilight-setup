#!/bin/bash

version(){
  echo " Version 0.1 - 2018 "
  echo " Tested on: Raspberry Pi 3 - OSMC - Hyperion 1.03.3 "
}

usage(){

  echo "Usage:
    sudo ./install.sh
    sudo ./install.sh [-f | --fan -c | --clock -b | --buttons -a | --assistant]
    sudo ./install.sh -h | --help
    sudo ./install.sh --version

Options:
    General options:
        -h --help           Show this screen.
        -v --version        Show version.
    Custom installation options:
        -a --assistant      Install Google Assistant script.
        -b --buttons        Install buttons script.
        -c --clock          Install clock effect.
        -f --fan            Install fan script.
    ( if you use any of the custom installation options
    you will install only the scripts/effects you specify
    instead of all the scripts/effects )
  "
}

clear
echo "                                  "
echo "   ______________            __   "
echo "  /___    ____/ /____  _____/ /_  "
echo " __  / / /_  / __/ _ \/ ___/ __ \ "
echo "/ /_/ / __/ / /_/  __/ /__/ / / / "
echo "\____/_/    \__/\___/\___/_/ /_/  "
echo "                                  "
echo "
Find out how to install both hardware and software for this project on YouTube
https://www.youtube.com/channel/UCHVYUIHCpWdqdW0ALlMS9Hg?sub_confirmation=1

Report bugs and get help on GitHub
https://github.com/JFtechOfficial/ultimate-ambilght-setup/issues
"

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
#silent option, output to /dev/null
#output=""
#if [ $-ne 0 ]; then
#  output=">/dev/null"# 2>&1"
#fi
#no arguments
default_install=$((fan+buttons+assistant+clock))
if [ $default_install -eq 0 ]; then
  fan=1
  buttons=1
  clock=1
  assistant=1
fi
startup=$((fan+buttons+assistant))

echo "This installation is going to install the following:
"

if [ $fan -ne 0 ]; then
  echo "- fan script
a script that controls a simple fan connected to the GPIO.
The fan will automatically start to spin and cool down the system 
varing its speed depending on the Rasperry Pi's CPU temperature.
  "
fi
if [ $buttons -ne 0 ]; then
  echo "- buttons script
a script that let you use buttons connected to the GPIO
to launch effects or color, to go back to the capture mode, 
turn on or safely turn off the Raspberry Pi. 
You can trigger different functions by pressing and long-pressing the buttons.
  "
fi
if [ $clock -ne 0 ]; then
  echo "- clock effect
a script that adds a new analog clock effect to the Hyperion effect list.
the second hand has a warmer color when outside is hot
and it has a colder color when outside is cold.
  "
fi
if [ $assistant -ne 0 ]; then
  echo "- Google Assistant script
a script that let you use the Google Assistant on your smartphone/tablet/Google Home
to tell Hyperion what to do (e.g. Hey Google, launch Rainbow swirl effect)
  "
fi
read -p "Do you want to procede? [y/N]: " installReply
if [[ "$installReply" =~ ^(yes|y|Y)$ ]]; then
  echo "Starting..."
else
  echo "Aborting..."
  exit 1
fi

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

#update before doing anything else
if [ $OS_OPENELEC -ne 1 ]; then
  echo "Updating System..."
  sudo apt-get update -y
  sudo apt-get autoremove -y
  sudo apt-get autoclean -y
fi

#Install dependencies and setup preperation
echo "Downloading and installing Python..."
sudo apt-get install -y build-essential
sudo apt-get install -y python
sudo apt-get install -y python-dev
sudo apt install -y python-pip
sudo apt-get install -y python-all-dev python-setuptools python-wheel

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

  echo "installing clock effect..."
  pip install -r Hyperion_effects/requirements.txt
  yes | sudo cp -rf Hyperion_effects/clock.py /usr/share/hyperion/effects/
  yes | sudo cp -rf Hyperion_effects/clock.json /usr/share/hyperion/effects/
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
  echo "installing nodejs and npm..."
  sudo apt-get install -y nodejs
  sudo apt-get install -y npm
  sudo npm i npm@latest -g
  npm cache clean --force
  echo "installing forever-service..."
  sudo npm install -g forever
  sudo npm install -g forever-service
fi
if [ $assistant -ne 0 ]; then
  git clone https://github.com/JFtechOfficial/hyperion-mqtt-subscriber.git
  echo "installing required modules for Google Assisant client script... "
  cat hyperion-mqtt-subscriber/requirements.txt | xargs npm install -g
  echo "installing Google Assisant client script... "
  sudo forever-service install assistant-service --script hyperion-mqtt-subscriber/client.js
  sudo service assistant-service start
fi
if [ $fan -ne 0 ]; then
  echo "Downloading fan script..."
  git clone https://github.com/JFtechOfficial/Raspberry-Pi-PWM-fan.git
  echo "installing fan script... "
  pip install -r Raspberry-Pi-PWM-fan/requirements.txt
  sudo forever-service install fan-service -s Raspberry-Pi-PWM-fan/fan.py -f " -c python"
  sudo service fan-service start
fi
if [ $buttons -ne 0 ]; then
  echo "installing buttons script..."
  pip install -r buttons/requirements.txt
  sudo forever-service install buttons-service -s buttons/buttons.py -f " -c python"
  sudo service buttons-service start
fi

echo
echo -n "REBOOT NOW? [y/N]"
read
if [[ "$REPLY" =~ ^(yes|y|Y)$ ]]; then
  echo "Reboot started..."
  reboot
else
  echo
  echo "Done!
  If You want to support me, you can donate here: https://ko-fi.com/jftech
  Thank you."
fi
