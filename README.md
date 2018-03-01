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
* A Raspberry Pi 2 or 3
* A microSD card with an OS installed ([OSMC](https://osmc.tv/download/) is suggested)

You can install [hyperion](https://hyperion-project.org) now or after the installation step




## 💾 Installation
Open a terminal window on your Raspberry Pi or connect via SSH (use the Terminal app on MacOS/Linux, download and use PuTTY on Windows) and run this command to download the `install.sh` file:
```shell
wget https://raw.githubusercontent.com/JFtechOfficial/ultimate-ambilght-setup/master/install.sh
```
you can modify the install.sh file if you don't want to install all the scripts

```shell
sudo chmod +x install.sh
sudo ./install.sh
```
if something goes wrong, please manually install all the [dependancies](#️-credits) and download all the fil

## ⚙️ Configuration

### Clock effect
* move both `clock.py` and `clock.json` to the Hyperion effects folder (this is the default path)
```shell
sudo mv clock.* /usr/share/hyperion/effects/
```
* [Get your OpenWeatherMap API key](http://openweathermap.org/appid) 
* open the `clock.json` file
```shell
sudo nano /usr/share/hyperion/effects/clock.json
```
* Paste the key in the `clock.json` file (you can use the same key in the kodi weather app)
* [Get your coordinates](https://support.google.com/maps/answer/18539?co=GENIE.Platform%3DDesktop&hl=en&oco=1) 
* Paste both latitude and longitude in the `clock.json` file
* You can modify the default colors of the "virutal" clock hands and add markers
* Save and close the file

### Buttons
* open the `buttons.py` file
```shell
nano /home/osmc/Development/buttons.py
```
* modify the `Pins` and `clear` variables to match your GPIO setup
* Save and close the file

### Fan
* open the `fan.py` file
```shell
nano /home/osmc/Development/fan.py
```
* modify the `pin` variable to match your GPIO setup
* you can modify the default `max_TEMP` variable (Temperature in Celsius after which the fan triggers),
`cutoff_TEMP` variable (Temerature in Celsius after which the fan stops) and `sleepTime` variable (Temperature reading interval in seconds) or you can activate one of the pre-made fan profile by uncommenting it
* Save and close the file


Remember to reboot your device after the configuration
```shell
sudo reboot
```

## ▶️ Usage

Use your favorite Hyperion client to select and run the clock effect, the second hand has a warmer color if outside is warm and it has a colder color if outside is cold.

Use buttons connected to the GPIO to launch a predefined hyperion effects, go back to the default mode, or safely turn off the Raspberry Pi.

The fan script requires you to do nothing, it's automated.


## 📚 Resources
Here is my step-by-step video guide to build the ultimate Ambilight setup: 
Hyperion-project: 

## 🎁 Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## ❤️ Credits

Major dependencies:
* python
* pyowm
* RPi.GPIO
* hyperion-project

The following programs have been a source of inspiration:


## 🎓 License

[MIT](http://webpro.mit-license.org/)


