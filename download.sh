#!/bin/bash

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

echo -n "Downloading button script..."
git clone https://github.com/JFtechOfficial/ultimate-ambilght-setup.git
if [ -d "buttons" ]; then
  yes | sudo cp -rf ultimate-ambilght-setup/buttons/buttons.py buttons
  echo -n "UPDATING"
else
  mv -T -f ultimate-ambilght-setup/buttons buttons
fi

echo -n "Downloading clock script..."
if [ -d "Hyperion_effects" ]; then
  yes | sudo cp -rf ultimate-ambilght-setup/Hyperion_effects/clock.py Hyperion_effects
  echo -n "UPDATING"
else
  mv -T -f ultimate-ambilght-setup/Hyperion_effects Hyperion_effects
fi

rm -rf ultimate-ambilght-setup

echo -n "Downloading Google Assisant client script..."
git clone https://github.com/JFtechOfficial/hyperion-mqtt-subscriber.git
if [ -d "Google_Assistant" ]; then
  yes | sudo cp -rf ultimate-ambilght-setup/hyperion-mqtt-subscriber/client.py Google_Assistant
  rm -rf hyperion-mqtt-subscriber
  echo -n "UPDATING"
else
  mv -T -f hyperion-mqtt-subscriber Google_Assistant
fi

echo -n "Downloading fan script..."
git clone https://github.com/JFtechOfficial/Raspberry-Pi-PWM-fan.git
if [ -d "fan" ]; then
  yes | sudo cp -rf ultimate-ambilght-setup/Raspberry-Pi-PWM-fan/fan.py fan
  rm -rf Raspberry-Pi-PWM-fan
  echo -n "UPDATING"
else
  mv -T -f Raspberry-Pi-PWM-fan fan
fi

echo "Done!
If You want to support me, you can donate here: https://ko-fi.com/jftech
Thank you."
