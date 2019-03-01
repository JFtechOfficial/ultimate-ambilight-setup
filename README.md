[![banner](https://dl.dropboxusercontent.com/s/xbczn9daprt7q2i/banner.png?dl=0 "banner with JFtech logo & social")](https://linktr.ee/jftechofficial)
[![Raspberry Pi](https://img.shields.io/badge/made%20for-Raspberry%20Pi-red.svg)](https://www.raspberrypi.org) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) ![license](https://img.shields.io/github/license/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub issues](https://img.shields.io/github/issues/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub top language](https://img.shields.io/github/languages/top/JFtechOfficial/ultimate-ambilght-setup.svg) ![Requires.io](https://img.shields.io/requires/github/JFtechOfficial/ultimate-ambilght-setup.svg)

Scripts that I created to enhance the Hyperion experience. You can also read this in [Italiano:it:](README-it-IT.md)


## 🚀 Getting started

<details>
 <summary><strong>Table of Contents</strong> (click to expand)</summary>

* [Getting started](#-getting-started)
* [Installation](#-installation)
* [Configuration](#️-manual-configuration)
* [Usage](#️-usage)
* [Resources](#-resources)
* [Contributing](#-contributing)
* [Credits](#️-credits)
* [Support Me!](#-support-me)
* [FAQ](#-faq)
* [Release History](#️-release-history)
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

* If you want you can [pre-configure](#️-configuration) the [Hyperion effects](#clock-effect) and [buttons script](#buttons). You can find them in the following directories: `Hyperion_effects`, `buttons`.


* Run the `install.sh` script:
```shell
sudo chmod 775 ~/ultimate-ambilight-setup/install.sh
sudo ~/ultimate-ambilight-setup/./install.sh
```

* You can decide what to install/reinstall using the `-a`, `-b`, `-c` and `-f` arguments (no custom installation arguments means "install everything").
```shell
Options:
    General options:
        -h --help           Show this screen.
        -v --version        Show version.
    Custom installation options:
        -a --assistant      Install Google Assistant script.
        -b --buttons        Install buttons script.
        -c --clock          Install clock effect.
        -f --fan            Install fan script.
```
* You now may [configure](#️-configuration) any .json files, including the ones for the [Google Assistant script](#google-assistant) and the [fan script](#fan). You can find them in the following directories: `hyperion-mqtt-subscriber`, `Raspberry-Pi-PWM-fan`.



## ⚙️ Configuration
You can change any configuration value after the [installation](#-installation) process. If you do, please remember to reboot your device afterwards
```shell
sudo reboot
```

### Clock Effect
* Open the `clock.json` file:
```shell
sudo nano ~/ultimate-ambilight-setup/Hyperion_effects/clock.json
```
* Get [your OpenWeatherMap API key](http://openweathermap.org/appid)
* Modify the `owmAPIkey` value pasting your API key (you can use the same API key in the Kodi Weather app btw)
* Get [your coordinates](https://www.whataremycoordinates.com/)
* Modify both `latitude` and `longitude` values pasting your own latitude and longitude
* Modify the `offset` value to match your LED setup
* Modify the `direction` value to match your LED setup ( `0` -> clockwise, `1` -> counterclockwise)
* You can modify the default colors and widths of the "virutal" clock hands and/or add markers
* Save `Ctrl + X` and close `Enter` the file
* If you want to modify the `clock.json` file AFTER the installation you can find it in the Hyperion effects directory:
```shell
sudo nano /usr/share/hyperion/effects/clock.json
```

*(example with the default path)*

### Buttons
* Open the `buttons.json` file:
```shell
nano ~/ultimate-ambilight-setup/buttons/buttons.json
```
* Modify the pins values to match your GPIO setup. AVOID using pin 5 (BOARD) a.k.a. GPIO 3 (BCM) for anything else than the power button: it's been hardcoded for you in this way and it cannot be changed for hardware related reasons. You DO NOT need to configure it in the `buttons.json` file.
* Modify the `short-press` and `long-press` values for each pin. You can assign an effect name (e.g. `"Rainbow swirl"`) to launch the effect, an RGB value (e.g. `[255,0,0]`) to launch the resulting color, the string `"clear"` to go back to the default capture mode, or `null` to do nothing. 

*I suggest you not modify:*
```
{
"short-press" : "clear",
"long-press" : [0,0,0]
}
```

* You can add as many buttons as you want by pasting (and configuring) the following code after `gpio-setup: {` :
```json
"Pin number" :
{
    "short-press" : "effect name"/[255,255,255]/null,
    "long-press" : "effect name"/[255,255,255]/null
},
```

* Modify the `gpio-mode` value to match the pin numbering you're using ("BCM"/"BOARD")
* Save `Ctrl + X` and close `Enter` the file

### Fan
* Open the `fan.json` file:
```shell
nano ~/ultimate-ambilight-setup/Raspberry-Pi-PWM-fan/fan.json
```
* Modify the `pin` value to match your GPIO setup
* Modify the `gpio-mode` value to match the pin numbering you're using ("BCM"/"BOARD")
* You can modify the other values to make sure your fan is working as intended
* Save `Ctrl + X` and close `Enter` the file

### Google Assistant
* Open the `client.json` file:
```shell
nano ~/ultimate-ambilight-setup/hyperion-mqtt-subscriber/client.json
```
* Modify the `ip_address` value of the `hyperion_server` to match the IP address of the device running Hyperion ("127.0.0.1" if it's the same device running this script)
* If you used a different port you can modify the default `port` value of the `hyperion_server`
* Create an [Adafruit-IO](https://io.adafruit.com/) account
* Create an "effect launching" topic, a "color launching" topic and an "effect clearing" topic (Feeds)
* Modify the `username` and `key` values of the `mqtt_broker` to match your Adafruit-IO username and AIO key
* Modify the `effect-topic` value of the `mqtt_broker` to match the name of your Adafruit-IO "effect launching" topic
* Modify the `color-topic` value of the `mqtt_broker` to match the name of your Adafruit-IO "color launching" topic
* Modify the `misc-topic` value of the `mqtt_broker` to match the name of your Adafruit-IO "miscellaneous" topic
* Modify the `ip_address` value of the `kodi_server` to match the IP address of the device running Kodi ("127.0.0.1" if it's the same device running this script)
* Modify the `video_uri` value of the `kodi_server` to the local path or internet link of the video you want to play (supported: YouTube, Dropbox, Flickr, GoogleDrive, Reddit, Twitch:video, Vimeo, VK and many more)
* Get [your Yandex API key](https://translate.yandex.com/developers/keys). Skip this step if you use English as main language
* Modify the `API_key` value with the Yandex API key. Simply set this value as blank (`""`) if you use English as main language
* Modify the `from_language` value to match your language
* You can add custom actions by pasting the following code after `"custom_actions": [` :
```json
{
"message": "your_message",
"target": "effect name"/[255,255,255]/"clear"/null
},
```
* Save `Ctrl + X` and close `Enter` the file


## ▶️ Usage

Use your favorite [Hyperion client](https://github.com/JFtechOfficial/hyperion-controller) to select and run the clock effect: the second hand has a warmer color when outside is hot and it has a colder color when outside is cold.

Use buttons connected to the GPIO to launch effects or color, to go back to the capture mode, or safely turn off the Raspberry Pi.

Use a fan connected to the GPIO: it will automatically start to spin when the CPU is above the max threshold and will automatically stop when the CPU is below the min threshold.

Use [IFTTT](https://ifttt.com/) to interface Google Assistant with the Adafruit-IO mqtt broker. You can send:
* to the "effect launching" topic *(the same topic assigned to* `effect-topic` *earlier)*
   * an effect name in order to activate that effect
* to the "color launching" topic *(the same topic assigned to* `color-topic` *earlier)*
   * a color name in order to activate that color
* to the "miscellaneous" topic *(the same topic assigned to* `misc-topic` *earlier)*
   * `OFF` in order to turn any effect/color off (goes back to capture mode)
   * `ON` in order to turn on the lights with white color
   * `PLAY` in order to play the video from `video_uri` while turning any effect off (goes back to capture mode)
   * `STOP` in order to stop any video (goes back to capture mode)

Now you can use the Google Assistant on your smartphone/tablet/Google Home to tell Hyperion what to do.


## 📚 Resources
Here is a step-by-step video guide about how to build the ultimate Ambilight setup: *TO-DO*


You can also check the [wiki](https://github.com/JFtechOfficial/ultimate-ambilght-setup/wiki)


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


## 💵 Support Me!

 [![ko-fi](https://www.ko-fi.com/img/donate_sm.png)](https://ko-fi.com/Y8Y0FW3V)


## 💭 FAQ

> Can I use the same GPIO pin for the configuration of two different scripts?

No. You should never use the same pin for different tasks at the same time (e.g. controlling the fan and reading the state of a button from the same pin at the same time will not work and could break your Raspberry Pi).

> Can I install the Google Assistant client script on a Raspberry Pi different from the one running Hyperion?

Yes. You can run it on any unix machine connected to the same local network: it will send commands to the Raspberry Pi that runs Hyperion. The fan script, buttons script and the clock effect cannot be used in the same way: you must install them on the machine that you intend to use them on.

> What about the Raspberry Pi Foundation TV µHAT?

I don't think I'll ever use one, IPTV is good enough imho.


## 🗓️ Release History

* 06/09/2018 - 0.1.0 - beta release


## 🎓 License

[MIT](http://webpro.mit-license.org/)
