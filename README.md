[![banner](https://dl.dropboxusercontent.com/s/xbczn9daprt7q2i/banner.png?dl=0 "banner with JFtech logo & social")](https://linktr.ee/jftechofficial)
[![Raspberry Pi](https://img.shields.io/badge/made%20for-Raspberry%20Pi-red.svg)](https://www.raspberrypi.org) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) ![license](https://img.shields.io/github/license/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub issues](https://img.shields.io/github/issues/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub top language](https://img.shields.io/github/languages/top/JFtechOfficial/ultimate-ambilght-setup.svg) ![Requires.io](https://img.shields.io/requires/github/JFtechOfficial/ultimate-ambilght-setup.svg)

Scripts that I created to enhance the Hyperion experience. You can also read this in [Italian🇮🇹](README-it-IT.md)


## 🚀 Getting started

<details>
 <summary><strong>Table of Contents</strong> (click to expand)</summary>

* [Getting started](#-getting-started)
* [Installation](#-installation)
* [Configuration](#️-configuration)
* [Usage](#️-usage)
* [Resources](#-resources)
* [Contributing](#-contributing)
* [Credits](#️-credits)
* [Support Me!](#️-dollar-support-me!)
* [Release History](#️-date-release-history)
* [License](#-license)
</details>

### Requirements
* A Raspberry Pi 2, 3 or 3+
* A microSD card with an OS already up and running ([OSMC](https://osmc.tv/download/) is suggested)

Make sure you have [Hyperion](https://hyperion-project.org) installed and configured (installation and configuration via [HyperCon](https://hyperion-project.org/wiki/HyperCon-Information) is suggested).


## 💾 Installation
* Open a terminal window on your Raspberry Pi or connect via SSH (use the Terminal app on MacOS/Linux, or download [PuTTY](https://www.putty.org) on Windows) and run this command to clone this repository on your device:
```shell
cd ~/ && sudo apt-get install git && git clone https://github.com/JFtechOfficial/ultimate-ambilght-setup.git
```
 * Prepare the install.sh script:
```shell
cd ~/ultimate-ambilight-setup/
sudo chmod 775 install.sh
```
* Now you can [manually configure](#️-configuration) any .json files you would like to install in both `Hyperion effects` and `scripts` directories. If you choose to do so you can omit the `-i` argument, otherwise skip the [Manual Configuration](#️-configuration) and follow the instruction provided during the execution of the `install.sh` script. You can decide what to install using the `-f`, `-b`, `-c` and `-a` arguments (no arguments means "install everything").
```shell
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
```

* Run the `install.sh` script:
```shell
sudo ./install.sh -s -i
```


## ⚙️ Manual Configuration
You can manually configure all the .json files you want to install before the execution of the `install.sh` script instead of using the interactive terminal via the `-i` argument. In both cases you'll have to provide the same information.
You can also change any configuration value after the [installation](#-installation) process. If you do, please remember to reboot your device afterwards
```shell
sudo reboot
```

### Clock effect
* Get [your OpenWeatherMap API key](http://openweathermap.org/appid) 
* Open the `clock.json` file:
```shell
sudo nano ~/ultimate-ambilight-setup/hyperion\ effects/clock.json
```
* Modify the `owmAPIkey` value pasting your API key (you can use the same key in the kodi weather app)
* Get [your coordinates](https://www.whataremycoordinates.com/) 
* Modify both `latitude` and `longitude` values pasting your own latitude and longitude
* Modify the `offset` value to match your LED setup
* Modify the `direction` value to match your LED setup ( `0` -> clockwise, `1` -> counterclockwise)
* You can modify the default colors and widths of the "virutal" clock hands and/or add markers
* Save `Ctrl + X` and close `Enter` the file
* If you want to modify the `clock.json` file after the installation you can find it in the Hyperion effects directory:
```shell
sudo nano /usr/share/hyperion/effects/clock.json
```
*(example with the default path)*

### Buttons
* Open the `buttons.json` file:
```shell
nano ~/ultimate-ambilight-setup/scripts/buttons.json
```
* Modify the `effects` and `clear` values to match your GPIO setup. Avoid using pin 3 (BCM) a.k.a. GPIO 5 (BOARD): it's already been hardcoded for you as power button ;)
* Save `Ctrl + X` and close `Enter` the file
### Fan
* Open the `fan.json` file:
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.json
```
* Modify the `pin` value to match your GPIO setup
* You can modify the default `max_TEMP` value (temperature in Celsius after which the fan triggers),
`cutoff_TEMP` value (temerature in Celsius after which the fan stops) and `sleepTime` value (temperature reading interval in seconds)
* Save `Ctrl + X` and close `Enter` the file

### Google Assistant
* Open the `client.json` file:
```shell
nano ~/ultimate-ambilight-setup/scripts/client.json
```
* Modify the `ip_address` value of the `hyperion_server` to match the IP address of the device running Hyperion ("127.0.0.1" if it's the same device running this script)
* If you used a different port you can modify the default `port` value of the `hyperion_server`
* Create an [Adafruit-IO](https://io.adafruit.com/) account
* Modify the `username` and `key` values of the `adafruit_mqtt_broker` to match your Adafruit-IO username and key
* Modify the `effect-topic` value of the `adafruit_mqtt_broker` to match your Adafruit-IO "effect launching" topic
* Modify the `other-topic` value of the `adafruit_mqtt_broker` to match your Adafruit-IO "effect clearing" topic
* Modify the `ip_address` value of the `kodi_server` to match the IP address of the device running kodi ("127.0.0.1" if it's the same device running this script)
* Modify the `video_uri` value of the `kodi_server` to the local path or internet link of the video you want to play (supported: YouTube, Dropbox, Flickr, GoogleDrive, Reddit, Twitch:video, Vimeo, VK and many more)
* Save `Ctrl + X` and close `Enter` the file


## ▶️ Usage

Use your favorite Hyperion client to select and run the clock effect, the second hand has a warmer color if outside is hot and it has a colder color if outside is cold.

Use buttons connected to the GPIO to launch your predefined Hyperion effects, go back to the default mode, or safely turn off the Raspberry Pi.

Use a fan connected to the GPIO: it will automatically start to spin when the CPU is above the `max_TEMP` threshold, and will automatically stop when the CPU is below the `cutoff_TEMP` threshold.

Use [IFTTT](https://ifttt.com/) to interface Google Assistant with the Adafruit-IO mqtt broker. You can send:
* to the "effect launching" topic *(the same topic assigned to *`effect-topic`* earlier)*
   * an effect name in order to activate an effect 
* to the "effect clearing" topic *(the same topic assigned to *`other-topic`* earlier)*
   * `OFF` in order to turn any Hyperion effect off
   * `ON` in order to turn on the `Dim cinema lights` effect (additional way to turn this effect on)
   * `PLAY` in order to play the video from `video_uri` while turning any Hyperion effect off (goes back to capture mode)
   * `STOP` in order to stop any video

Now you can use the Google Assistant on your smartphone/tablet/Google Home to tell Hyperion what to do. 


## 📚 Resources
Here is a step-by-step video guide about how to build the ultimate Ambilight setup: *TO-DO*

The `hyperion.config.json` file is an example of a working configuration file for Hyperion (generated via [HyperCon](https://github.com/hyperion-project/hypercon))

Please visit the [hyperion-project website](https://hyperion-project.org) to learn more about Hyperion


## 🎁 Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md).


## ❤️ Credits

Major dependencies:
* [pyowm](https://github.com/csparpa/pyowm)
* [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)
* [hyperion](https://github.com/hyperion-project/hyperion)
* [node-hyperion-client](https://github.com/WeeJeWel/node-hyperion-client)
* [play-on-kodi](https://github.com/ritiek/play-on-kodi)


The following user has been a source of inspiration: [7h30n3 (The One)](https://github.com/7h30n3) <3


## 💵 Support Me!

 [![ko-fi](https://www.ko-fi.com/img/donate_sm.png)](https://ko-fi.com/Y8Y0FW3V)



## 🗓️ Release History

* 0.1.0 - beta release


## 🎓 License

[MIT](http://webpro.mit-license.org/)


