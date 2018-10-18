#!/bin/bash

version(){
  echo " Version 0.1 - 2018 "
  echo " Tested on: Raspberry Pi 3 - OSMC - Hyperion 1.03.3 "
}

usage(){

  echo "Usage:
    sudo ./download.sh
    sudo ./download.sh [-f | --fan -c | --clock -b | --buttons -a | --assistant]
    sudo ./download.sh -h | --help
    sudo ./download.sh --version

Options:
    General options:
        -h --help           Show this screen.
        -v --version        Show version.
    Custom download options:
        -a --assistant      download Google Assistant script.
        -b --buttons        download buttons script.
        -c --clock          download clock effect.
        -f --fan            download fan script.
    ( if you use any of the custom download options
    you will download only the scripts/effects you specify
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

fan=0
buttons=0
clock=0
assistant=0

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
  echo '---> Critical Error: Please run the script as root (sudo ./download.sh) -> abort'
  exit 1
fi
#Check, if year equals 1970
DATE=$(date +"%Y")
if [ "$DATE" -le "2017" ]; then
  echo "---> Critical Error: Please update your systemtime (Year of your system: ${DATE}) -> abort"
  exit 1
fi

default_install=$((fan+buttons+assistant+clock))
if [ $default_install -eq 0 ]; then
  fan=1
  buttons=1
  clock=1
  assistant=1
fi

echo "This is going to download the following:
"

if [ $fan -ne 0 ]; then
  echo "- fan script
a script that controls a fan using a GPIO pin.
  "
fi
if [ $buttons -ne 0 ]; then
  echo "- buttons script
A script that let you use buttons connected to the GPIO
to launch effects/colors, go back to the capture mode, or safely turn off the Raspberry Pi.
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
to tell Hyperion what to do (e.g. Ok Google, launch Rainbow swirl effect)
  "
fi
read -p "Do you want to procede? [Y/n]: " installReply
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
if [ $OS_OPENELEC -ne 0 ]; then
  echo '---> Critical Error: This script is not compatible with OpenELEC -> abort'
  exit 1
fi

if [ $clock -ne 1 ]; then
  sudo rm -rf Hyperion_effects/
fi
if [ $assistant -ne 0 ]; then
  echo -n "Douwnloading Google Assisant client script..."
  git clone https://github.com/JFtechOfficial/hyperion-mqtt-subscriber.git
  mv -T -f hyperion-mqtt-subscriber Google_Assistant
fi
if [ $fan -ne 0 ]; then
  echo -n "Downloading fan script..."
  git clone https://github.com/JFtechOfficial/Raspberry-Pi-PWM-fan.git
  mv -T -f Raspberry-Pi-PWM-fan fan
fi
if [ $buttons -ne 1 ]; then
  sudo rm -rf buttons/
fi

echo "Done!
If You want to support me, you can donate here: https://ko-fi.com/jftech
Thank you."
