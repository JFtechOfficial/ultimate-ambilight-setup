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
        -i --interactive    Insert installation parameters during installation.
        -s --silent         Show less stuff during installation.
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
#silent option, output to /dev/null
output=""
if [ $silent -ne 0 ]; then
  output=" > /dev/null 2>&1" # 1,2, oppure & ???
fi
#no arguments
default_install=$((fan+buttons+assistant+clock))
if [ $default_install -eq 0 ]; then
  fan=1
  buttons=1
  clock=1
  assistant=1
fi
startup=$((fan+buttons+assistant))
gpio=$((fan+buttons))

#confirmation
if [ $interactive -ne 0 ]; then
  echo "This installation is going to install the following:
  "

  if [ $fan -ne 0 ]; then
    echo "- fan script
  a script that controls a fan (on/off) using a GPIO pin.
  The fan will automatically start to spin when the CPU is above the max_TEMP threshold
  and will automatically stop when the CPU is below the cutoff_TEMP threshold.
    "
  fi
  if [ $buttons -ne 0 ]; then
    echo "- buttons script
  A script that let you use buttons connected to the GPIO
  to launch effects, go back to the capture mode, or safely turn off the Raspberry Pi.
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
  to tell Hyperion what to do (e.g. Ok, Google launch Rainbow swirl effect)
    "
  fi
  read -p "Do you want to procede? [Y/n]: " installReply
  if [[ "$installReply" =~ ^(yes|y|Y)$ ]]; then
    echo "Starting..."
  else
    echo "Aborting..."
    exit 1
  fi
fi

#regex
re='^-?[0-9]+[.][0-9]+$'
rei='^[123456789]+[0-9]*$'
reb='^[01]$'
reip='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
reboard='^(([3578])|([1][01235689])|([2][12346]))$'
reboardb='^(([378])|([1][01235689])|([2][12346]))$'

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
  echo -n "Updating System..."
  sudo apt-get update -y $output
  ##sudo apt-get upgrade -y
  ##sudo apt-get dist-upgrade -y
  sudo apt-get autoremove -y $output
  sudo apt-get autoclean -y $output
fi

#Install dependencies and setup preperation
echo -n "Downloading and installing Python..."
sudo apt-get install -y build-essential
sudo apt-get install -y python
sudo apt-get install -y python-dev
sudo apt install -y python-pip
##curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
##python get-pip.py
if [ $gpio -ne 0 ]; then
  echo "Downloading Rpi.GPIO..."
  sudo wget https://pypi.python.org/packages/source/R/RPi.GPIO/RPi.GPIO-0.6.2.tar.gz
  echo "installing Rpi.GPIO..."
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
  if [ $interactive -ne 0 ]; then
    echo "
Enter your OpenWeatherMap API key.
Leave empty if you don't want to modify the old value.
You can get a new API key here: https://openweathermap.org/appid
    "
    read -p "OpenWeatherMap API key: " OWMkey

    echo "
Enter your own latitude and longitude.
Leave empty if you don't want to modify the old value.
You can find your coordinates here: https://www.whataremycoordinates.com/
    "
    while read -p "Latitude: " lat; do
      if ! { [[ $lat  =~ $re ]] || [ -z $lat ]; }; then
        echo "Latitude must be a decimal number"
      else
        if ! [ -z $lat ]; then
          sudo python jsonHelper.py 'Hyperion_effects/clock.json' 'latitude' $lat
        fi
        break
      fi
    done
    while read -p "Longitude: " lon; do
      if ! { [[ $lon  =~ $re ]] || [ -z $lon ]; }; then
        echo "Longitude must be a decimal number"
      else break
      fi
    done

    echo "
Enter your LED stip offset number.
Leave empty if you don't want to modify the old value.
    "
    while read -p "Offset: " ofs; do
      if ! { [[ $ofs  =~ $rei ]] || [ -z $ofs ]; }; then
        echo "Offset must be an integer number"
      else break
      fi
    done

    echo "
Enter the direction of your LED stip.
0 -> clockwise, 1 -> counterclockwise.
Leave empty if you don't want to modify the old value.
    "
    while read -p "Direction: " direc; do
      if ! { [[ $direc  =~ $reb ]] || [ -z $direc ]; }; then
        echo "Direction must be 0 or 1"
      else break
      fi
    done

    echo "$OWMkey $lat $lon $ofs $direc"
  fi

  ######################################
  echo -n "installing clock effect..."
  sudo mv Hyperion_effects/clock.py /usr/share/hyperion/effects/
  sudo mv Hyperion_effects/clock.json /usr/share/hyperion/effects/
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
  echo "
Enter the IP address of the device running Hyperion.
Leave empty if you don't want to modify the old value.
  "
  while read -p "IP address: " IPaddressH; do
    if ! { [[ $IPaddressH  =~ $reip ]] || [ -z $IPaddressH ]; }; then
      echo "IP address must be in the 'num.num.num.num' format"
    else
      if ! [ -z $lat ]; then
        sudo python jsonHelper.py 'scripts/client.json' 'hyperion_server' 'ip_address' $IPaddressH
      fi
      break
    fi
  done

  echo "
Enter your Adafruit-IO username.
Leave empty if you don't want to modify the old value.
You can get a new account here: https://io.adafruit.com
  "
  read -p "Your username: " IOuser
  if ! [ -z $IOuser ]; then
    sudo python jsonHelper.py 'scripts/client.json' 'adafruit_mqtt_broker' 'username' $IOuser
  fi

  echo "
Enter your Adafruit-IO AIO key.
Leave empty if you don't want to modify the old value.
You can get a new key here: https://io.adafruit.com
  "
  read -p "Your AIO key: " IOkey
  if ! [ -z $IOkey ]; then
    sudo python jsonHelper.py 'scripts/client.json' 'adafruit_mqtt_broker' 'key' $IOkey
  fi
  echo "
Enter your Adafruit-IO 'effect launching' topic.
Leave empty if you don't want to modify the old value.
You can create a new topic (feed) here: https://io.adafruit.com
  "
  read -p "effect_topic: " IOeffect
  if ! [ -z $IOeffect ]; then
    sudo python jsonHelper.py 'scripts/client.json' 'adafruit_mqtt_broker' 'topics' 'effect_topic' $IOeffect
  fi
  echo "
Enter your Adafruit-IO 'effect clearing' topic.
Leave empty if you don't want to modify the old value.
You can create a new topic (feed) here: https://io.adafruit.com
  "
  read -p "other_topic: " IOclear
  if ! [ -z $IOclear ]; then
    sudo python jsonHelper.py 'scripts/client.json' 'adafruit_mqtt_broker' 'topics' 'other_topic' $IOclear
  fi
  echo "
Enter the IP address of the device running Kodi.
Leave empty if you don't want to modify the old value.
  "
  while read -p "IP address: " IPaddressK; do
    if ! { [[ $IPaddressK  =~ $reip ]] || [ -z $IPaddressK ]; }; then
      echo "IP address must be in the 'num.num.num.num' format"
    else
      if ! [ -z $IPaddressK ]; then
        sudo python jsonHelper.py 'scripts/client.json' 'kodi_server' 'ip_address' $IPaddressK
      fi
      break
    fi
  done

  echo "
Enter the local path or web link to the video you want to play.
Leave empty if you don't want to modify the old value.
  "
  read -p "video uri: " videouri
  if ! [ -z $videouri ]; then
    sudo python jsonHelper.py 'scripts/client.json' 'kodi_server' 'video_uri' $videouri
  fi
  echo -n "installing Google Assisant client script..."
  sudo forever-service install assistant-service --script scripts/client.js
  sudo service assistant-service start
fi
if [ $fan -ne 0 ]; then
  echo "
Enter th pin number (BOARD) for the fan.
Leave empty if you don't want to modify the old value.
  "
  while read -p "GPIO pin: " gpiopin; do
    if ! { [[ $gpiopin  =~ $reboard ]] || [ -z $gpiopin ]; }; then
      echo "Pin must be in the BOARD pin numbering"
    else
      if ! [ -z $gpiopin ]; then
        sudo python jsonHelper.py 'scripts/fan.json' 'pin' $gpiopin
      fi
      break
    fi
  done
  echo -n "installing fan script..."
  sudo forever-service install fan-service -s scripts/fan.py -f " -c python"
  sudo service fan-service start
fi
if [ $buttons -ne 0 ]; then
  echo "
Enter the name of an effect and pin number (BOARD) for the effect buttons.
Leave empty if you don't want to modify the pin's old value.
  "
  eArray=()
  itr=0
  while read -p "Do you want to add an effect button? [Y/n]: " Yreply; do
    if [[ "$Yreply" =~ ^(yes|y|Y)$ ]]; then
      read -p "effect name: " ename
      while read -p "GPIO pin: " ebutton; do
        if ! { [[ $ebutton  =~ $reboardb ]] || [ -z $ebutton ]; }; then
          echo "Pin must be in the BOARD pin numbering (pin 5 not allowed)"
        else
          if ! [ -z $ebutton ]; then
            sudo python jsonHelper.py 'scripts/buttons.json' 'effects' $ename $ebutton
          fi
          break
        fi
      done
    else break
    fi
  done
  echo "
Enter th pin number (BOARD) for the clear button.
Leave empty if you don't want to modify the old value.
  "
  while read -p "GPIO pin: " cbutton; do
    if ! { [[ $cbutton  =~ $reboardb ]] || [ -z $cbutton ]; }; then
      echo "Pin must be in the BOARD pin numbering (pin 5 not allowed)"
    else
      if ! [ -z $cbutton ]; then
        sudo python jsonHelper.py 'scripts/buttons.json' 'clear' $cbutton
      fi
      break
    fi
  done
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
  echo "Done!
  If You want to support me, you can donate here: https://ko-fi.com/jftech
  Thank you."
fi
