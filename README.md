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

Make sure you have [hyperion](https://hyperion-project.org) installed and configured. (installation and configuration via [HyperCon](https://hyperion-project.org/wiki/HyperCon-Information) is suggested).


## 💾 Installation
Open a terminal window on your Raspberry Pi or connect via SSH (use the Terminal app on MacOS/Linux, or download [PuTTY](https://www.putty.org) on Windows) and run this command:
```shell
cd ~/ && sudo apt-get install git && git clone https://github.com/JFtechOfficial/ultimate-ambilght-setup.git
```
 It will download clone this repository on your computer. You can now run the install.sh script
```shell
cd ~/ultimate-ambilight-setup/
sudo chmod +x install.sh
```
(if you choose you can configure all the .json files in both `Hyperion effects` and `scripts` directories now. If you do so you can omit the `-i` argument)
```shell
sudo ./install.sh -i
```

## ⚙️ Configuration


### Clock effect
* Get [your OpenWeatherMap API key](http://openweathermap.org/appid) 
* Open the `clock.json` file
```shell
sudo nano ~/ultimate-ambilight-setup/hyperion\ effects/clock.json
```
* Modify the `owmAPIkey` value (empty by default) pasting your API key (you can use the same key in the kodi weather app)
* Get [your coordinates](https://support.google.com/maps/answer/18539?co=GENIE.Platform%3DDesktop&hl=en&oco=1) 
* Modify both `latitude` and `longitude` values with your latitude and longitude
* You can modify the default colors of the "virutal" clock hands and add markers
* Save and close the file
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
* Modify the `effects` and `clear` values to match your GPIO setup
* Save and close the file

### Fan
* Open the `fan.json` file
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.json
```
* Modify the `pin` value to match your GPIO setup
* You can modify the default `max_TEMP` value (Temperature in Celsius after which the fan triggers),
`cutoff_TEMP` value (Temerature in Celsius after which the fan stops) and `sleepTime` value (Temperature reading interval in seconds).  or you can find some pre-made fan profiles in the `fan.py` file
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.py
```
* Save and close the file


Remember to reboot your device after the configuration
```shell
sudo reboot
```

## ▶️ Usage

Use your favorite Hyperion client to select and run the clock effect, the second hand has a warmer color if outside is hot and it has a colder color if outside is cold.

Use buttons connected to the GPIO to launch your predefined hyperion effects, go back to the default mode, or safely turn off the Raspberry Pi.

The fan script requires you to do nothing, it's automated.


## 📚 Resources
Here is my step-by-step video guide about how to build the ultimate Ambilight setup: *TO-DO*

The `hyperion.config.json` file is an example of a working configuration file for hyperion (generated via [HyperCon](https://github.com/hyperion-project/hypercon))

Please visit the [hyperion-project website](https://hyperion-project.org) and support the developers!

## 🎁 Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## ❤️ Credits

Major dependencies:
* [python](https://www.python.org)
* [pyowm](https://github.com/csparpa/pyowm)
* [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)
* [hyperion](https://github.com/hyperion-project/hyperion)

The following user have been a source of inspiration: [7h30n3 (The One)](https://github.com/7h30n3)


## 🎓 License

[MIT](http://webpro.mit-license.org/)


