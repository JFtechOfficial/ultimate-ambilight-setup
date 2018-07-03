[![banner](https://dl.dropboxusercontent.com/s/xbczn9daprt7q2i/banner.png?dl=0 "banner with JFtech logo & social")](https://linktr.ee/jftechofficial)
[![Raspberry Pi](https://img.shields.io/badge/made%20for-Raspberry%20Pi-red.svg)](https://www.raspberrypi.org) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) ![license](https://img.shields.io/github/license/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub issues](https://img.shields.io/github/issues/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub top language](https://img.shields.io/github/languages/top/JFtechOfficial/ultimate-ambilght-setup.svg) ![Requires.io](https://img.shields.io/requires/github/JFtechOfficial/ultimate-ambilght-setup.svg)

Scripts I created to enhance the Hyperion experience. You can also read this in [Italian🇮🇹](README-it-IT.md)

## 🚀 Getting started
??? lorem ipsum ???
<details>
 <summary><strong>Table of Contents</strong> (click to expand)</summary>

* [Getting started](#-getting-started)
* [Installation](#-installation)
* [Configuration](#️-configuration)
* [Usage](#️-usage)
* [Resources](#-resources)
* [Contributing](#-contributing)
* [Credits](#️-credits)
* [License](#-license)
</details>

### Requirements
* A Raspberry Pi 2, 3 or 3+
* A microSD card with an OS already up and running ([OSMC](https://osmc.tv/download/) is suggested)

Make sure you have [Hyperion](https://hyperion-project.org) installed and configured. (installation and configuration via [HyperCon](https://hyperion-project.org/wiki/HyperCon-Information) is suggested).


## 💾 Installation
* Open a terminal window on your Raspberry Pi or connect via SSH (use the Terminal app on MacOS/Linux, or download [PuTTY](https://www.putty.org) on Windows) and run this command to clone this repository on your device:
```shell
cd ~/ && sudo apt-get install git && git clone https://github.com/JFtechOfficial/ultimate-ambilght-setup.git
```
 * You can run the install.sh script (if you choose you can configure all the .json files in both `Hyperion effects` and `scripts` directories now. If you do so you can omit the `-i` argument)
```shell
cd ~/ultimate-ambilight-setup/
sudo chmod +x install.sh
sudo ./install.sh -i
```

## ⚙️ Configuration
If you change any configuration value after you completed the installation process please remember to reboot your device afterwards
```shell
sudo reboot
```

### Clock effect
* Get [your OpenWeatherMap API key](http://openweathermap.org/appid) 
* Open the `clock.json` file
```shell
sudo nano ~/ultimate-ambilight-setup/hyperion\ effects/clock.json
```
* Modify the `owmAPIkey` value (empty by default) pasting your API key (you can use the same key in the kodi weather app)
* Get [your coordinates](https://support.google.com/maps/answer/18539?co=GENIE.Platform%3DDesktop&hl=en&oco=1) 
* Modify both `latitude` and `longitude` values pasting your latitude and longitude
* You can modify the default colors of the "virutal" clock hands and add markers
* Save `Ctrl + X`and close `Enter` the file
* If you want to modify the `clock.json` file after the installation you can find it in the Hyperion effects directory
```shell
sudo nano /usr/share/hyperion/effects/clock.json
```
(example with the default path)

### Buttons
* Open the `buttons.json` file
```shell
nano ~/ultimate-ambilight-setup/scripts/buttons.json
```
* Modify the `effects` and `clear` values to match your GPIO setup. Avoid using pin 3 (BCM) a.k.a. GPIO 5 (BOARD): it's already hardcoded as power button for you ;)
* Save `Ctrl + X`and close `Enter` the file
### Fan
* Open the `fan.json` file
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.json
```
* Modify the `pin` value to match your GPIO setup
* You can modify the default `max_TEMP` value (Temperature in Celsius after which the fan triggers),
`cutoff_TEMP` value (Temerature in Celsius after which the fan stops) and `sleepTime` value (Temperature reading interval in seconds). You can find some pre-made fan profiles in the `fan.py` file
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.py
```
* Save `Ctrl + X`and close `Enter` the file

### Google Assistant
* Open the `client.json` file
```shell
nano ~/ultimate-ambilight-setup/scripts/client.json
```
* Modify the `ip_address` value of the `hyperion_server` to match the IP address of the device running Hyperion ("127.0.0.1" if it's the same device running this script)
* If You used a different port you can modify the default `port` value of the `hyperion_server`
* Create an [Adafruit-IO](https://io.adafruit.com/) account
* Modify the `username` and `key` values of the `adafruit_mqtt_broker` to match your Adafruit-IO username and key
* Modify the `effect-topic`value of the `adafruit_mqtt_broker` to match your Adafruit-IO "effect launching" topic
* Modify the `other-topic` value of the `adafruit_mqtt_broker` to match your Adafruit-IO "effect clearing" topics
* Modify the `ip_address` value of the `kodi_server` to match the IP address of the device running kodi ("127.0.0.1" if it's the same device running this script)
* Modify the `video_uri` value of the `kodi_server` to the local path or internet link of the video you want to play (supported: YouTube, HotStar, and many more)
* Save `Ctrl + X`and close `Enter` the file

Use [IFTT](https://ifttt.com/) to interface Google Assistant with the Adafruit-IO mqtt broker.
* to the same topic as the `effect-topic` you can send an effect name in order to activate an effect 
* to the same topic as the `other-topic` you can send 
     * `OFF` in order to turn any Hyperion effect off
     * `ON` in order to turn on the `Dim cinema lights` effect (additional way to turn on this effect)
     * `PLAY` in order to play the video from `video_uri` while turning any Hyperion effect off
     * `STOP` in order to stop any video

## ▶️ Usage

Use your favorite Hyperion client to select and run the clock effect, the second hand has a warmer color if outside is hot and it has a colder color if outside is cold.

Use buttons connected to the GPIO to launch your predefined Hyperion effects, go back to the default mode, or safely turn off the Raspberry Pi.

The fan script requires you to do nothing, it's automated.

Use the Google Assistant on your smartphone/tablet/Google home to tell Hyperion what to do. 

## 📚 Resources
Here is my step-by-step video guide about how to build the ultimate Ambilight setup: *TO-DO*

The `hyperion.config.json` file is an example of a working configuration file for Hyperion (generated via [HyperCon](https://github.com/hyperion-project/hypercon))

Please visit the [hyperion-project website](https://hyperion-project.org) and support the developers!

## 🎁 Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## ❤️ Credits

Major dependencies:
* [pyowm](https://github.com/csparpa/pyowm)
* [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)
* [hyperion](https://github.com/hyperion-project/hyperion)
* [node-hyperion-client](https://github.com/WeeJeWel/node-hyperion-client)
* [play-on-kodi](https://github.com/ritiek/play-on-kodi)


The following user have been a source of inspiration: [7h30n3 (The One)](https://github.com/7h30n3) <3


## 🎓 License

[MIT](http://webpro.mit-license.org/)


