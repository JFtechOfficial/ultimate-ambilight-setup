[![banner](https://dl.dropboxusercontent.com/s/xbczn9daprt7q2i/banner.png?dl=0 "banner with JFtech logo & social")](https://linktr.ee/jftechofficial)
[![Raspberry Pi](https://img.shields.io/badge/made%20for-Raspberry%20Pi-red.svg)](https://www.raspberrypi.org) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) ![license](https://img.shields.io/github/license/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub issues](https://img.shields.io/github/issues/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub top language](https://img.shields.io/github/languages/top/JFtechOfficial/ultimate-ambilght-setup.svg) ![Requires.io](https://img.shields.io/requires/github/JFtechOfficial/ultimate-ambilght-setup.svg)

Scripts che ho creato per migliorare l'esperienza con Hyperion. You can also read this in [English:gb:](README.md)


## 🚀 Getting started

<details>
 <summary><strong>Lista dei Contenuti</strong> (clicca per espandere)</summary>

* [Getting started](#-getting-started)
* [Installazione](#-installazione)
* [Configurazione](#️-configurazione-manuale)
* [Uso](#️-uso)
* [Risorse](#-risorse)
* [Contribuire](#-contribuire)
* [Crediti](#️-crediti)
* [Supportami!](#-supportami)
* [Release History](#️-release-history)
* [Licenza](#-licenza)
</details>

### Requisiti
* Un Raspberry Pi 2, 3 o 3+
* Una microSD con un OS installato e pronto all'uso (è consigliato [OSMC](https://osmc.tv/download/))

Assicurati di avere [Hyperion](https://hyperion-project.org) installato e configurato (è consigliato l'installazione e la configurazione via [HyperCon](https://hyperion-project.org/wiki/HyperCon-Information)).


## 💾 Installazione
* Apri una finestra del terminale sul tuo Raspberry Pi o connettiti via SSH (usa l'app Terminale su MacOS/Linux, o scarica [PuTTY](https://www.putty.org) su Windows) e esegui questo comando per clonare questa repository sul tuo dispositivo:
```shell
cd ~/ && sudo apt-get install git && git clone https://github.com/JFtechOfficial/ultimate-ambilght-setup.git
```
 * Prepara lo script install.sh:
```shell
cd ~/ultimate-ambilight-setup/
sudo chmod 775 install.sh
```
* Ora puoi [configurare manualmente](#️-configurazione) i file .json che vuoi installare, sia nella cartella `Hyperion effects` che nella cartella `scripts` . Se decidi di farlo puoi omettere l'argomento `-i` , altrimenti salta la [Configurazione Manuale](#️-configurazione) e segui le istruzioni fornite durante l'esecuzione dello script `install.sh` . Puoi decidere consa intallare usando gli argomenti `-f`, `-b`, `-c` e `-a` (nessun argomento significa "installa tutto").
```shell
Opzioni:
    Opzioni generali:
        -h --help           Mostra questa schermata.
        -v --version        Mostra versione.
        -s --silent         Mostra meno roba durante l'installazione.
        -i --interactive    Inserisci i parametri di installazione durante l'installazione.
    Opzioni di installazione personalizzata:
        -f --fan            Installa lo script per la ventola.
        -c --clock          Installa l'effetto orologio.
        -b --buttons        Installa lo script per i pulsanti.
        -a --assistant      Installa lo script per Google Assistant.
```

* Esegui lo script `install.sh` :
```shell
sudo ./install.sh -s -i
```


## ⚙️ Configurazione Manuale
Puoi configurare manualmente tutti i file .json che vuoi installare prima dell'esecuzione dello script `install.sh` invece di usare il terminale interattivo tramite l'argomento `-i` . In entrambi i casi dovrai fornire le stesse informazioni.
Puoi anche cambiare qualsiasi valore di configurazione dopo il processo di [installazione](#-installazione) . Se lo fai, ricordati di riavviare il sistema:
```shell
sudo reboot
```

### Effetto Orologio
* Ottieni [la tua API key di OpenWeatherMap](http://openweathermap.org/appid) 
* Apri il file `clock.json` :
```shell
sudo nano ~/ultimate-ambilight-setup/hyperion\ effects/clock.json
```
* Modifica il valore di `owmAPIkey` incollando la tua API key (puoi usare la stessa key nell' app meteo di kodi)
* Ottieni [le tue coordinate](https://www.whataremycoordinates.com/) 
* Modifica i valori di `latitude` e `longitude` incollando la tua latitudine e longitudine
* Modifica il valore di `offset` per farlo combaciare con il setup dei tuoi LED
* Modifica il valore di `direction` per farlo combaciare con il setup dei tuoi LED ( `0` -> senso orario, `1` -> senso antiorario)
* Puoi modificare i colori e le larghezze di default delle lancette "virutali" e/o aggiungere markers
* Salva `Ctrl + X` e chiudi il file `Enter`
* Se vuoi modificare il file `clock.json` dopo l'installazione puoi trovarlo nella cartella degli effetti di Hyperion:
```shell
sudo nano /usr/share/hyperion/effects/clock.json
```
*(esempio con il persorso di default)*

### Pulsanti
* Apri il file `buttons.json` :
```shell
nano ~/ultimate-ambilight-setup/scripts/buttons.json
```
*  Modifica i valori di `effects` e `clear` per farlo combaciare con il setup dei tuoi pin di GPIO. Evita di usare il pin 3 (BCM) a.k.a. GPIO 5 (BOARD): è già stato hardcoded per te come pulsante di accensione/spegnimento del Raspberry Pi ;)
* Salva `Ctrl + X` e chiudi il file `Enter`

### Ventola
* Apri il file `fan.json` :
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.json
```
* Modifica il valore di `pin`  per farlo combaciare con il setup dei tuoi pin di GPIO
* Puoi modificare il valore di default di `max_TEMP` (temperatura in Celsius dopo la quale la ventola comincia a girare),
`cutoff_TEMP` (temperatura in Celsius dopo la quale la ventola si ferma) e `sleepTime` (intervallo di letturs della temperature in secondi)
* Salva `Ctrl + X` e chiudi il file `Enter`

### Google Assistant
* Apri il file `client.json` :
```shell
nano ~/ultimate-ambilight-setup/scripts/client.json
```
* Modifica il valore di `ip_address` dell' `hyperion_server` per farlo combaciare con l'indirizzo IP del dispositivo su cui è in esecuzione Hyperion ("127.0.0.1" se è lo stesso dispositivo che fa girare lo script)
* Se hai usato una porta differente puoi modificare il valore di default di `port` dell' `hyperion_server`
* Crea un account su [Adafruit-IO](https://io.adafruit.com/)
* crea un topic (feed) per "lanciare un effetto" e uno per "spegnere un effetto"
* Modifica i valori di `username` e `key` dell' `adafruit_mqtt_broker` per farli combaciare con lo username e la AIO key di Adafruit-IO
* Modifica il valore di `effect-topic` dell' `adafruit_mqtt_broker` per farlo combaciare con il nome del tuo topic di Adafruit-IO per "laciare un effetto"
* Modifica il valore di `other-topic` dell' `adafruit_mqtt_broker`  per farlo combaciare con il nome del tuo topic di Adafruit-IO per "spegnere un effetto"
* Modifica il valore di `ip_address` del `kodi_server` per farlo combaciare con l'indirizzo IP del dispositivo su cui è in esecuzione kodi ("127.0.0.1" se è lo stesso dispositivo che fa girare lo script)
* Modifica il valore di `video_uri` del `kodi_server` con il percorso locale o il link da internet del video che vuoi riprodurre (supportati: YouTube, Dropbox, Flickr, GoogleDrive, Reddit, Twitch:video, Vimeo, VK e molti altri)
* Salva `Ctrl + X` e chiudi il file `Enter`


## ▶️ Uso

Usa il tuo [client di Hyperion](https://play.google.com/store/apps/details?id=nl.hyperion.hyperionfree&hl=it_IT) pereferito per selezionare e lanciare l'effetto orologio: la lancetta dei secondi avrà un colore più caldo se fuori fa caldo e un colore più freddo se fuori fa freddo.

Usa dei pulsanti connessi al GPIO per avviare i gli effetti di Hyperion che hai predefinito, tornare alla modalità cattura, o spegnere in maniera sicura il tuo Raspberry Pi.

Usa una ventola connessa al GPIO: comincerà a girare automaticamente quando la CPU è sopra la soglia di `max_TEMP` e si fermerà automaticamente quando la CPU è sotto la soglia di `cutoff_TEMP`.

Usa [IFTTT](https://ifttt.com/) per interfacciare Google Assistant con il broker mqtt di Adafruit-IO. Puoi inviare:
* al topic di Adafruit-IO per "lanciare un effetto" *(lo stesso topic assegnato a* `effect-topic` *in precedenza)*
   * il nome di un effetto per lanciare quell'effetto
* al topic di Adafruit-IO per "spegnere un effetto" *(lo stesso topic assegnato a* `other-topic` *in precedenza)*
   * `OFF` per spegnere qualsiasi effetto
   * `ON` per accendere l'effetto `Dim cinema lights` (maniera aggiuntiva per avviare questo effetto)
   * `PLAY` per riprodurre il video da `video_uri` e contemporaneamente spegnere qualsiasi effetto (torna in modalità cattura)
   * `STOP` per interrompere qualsiasi video

Ora puoi usare Google Assistant sul tuo smartphone/tablet/Google Home per dire a Hyperion cosa fare. 


## 📚 Risorse
Ecco una video guida passo-passo su come costruire l'ultimate Ambilight setup: *TO-DO*

Il file `hyperion.config.json` è un esempio di un file di configurazione funzionalte per Hyperion (generato via [HyperCon](https://github.com/hyperion-project/hypercon))

Visita [il sito hyperion-project](https://hyperion-project.org) per avere maggiori informazioni su Hyperion


## 🎁 Contribuire

Leggi [CONTRIBUTING.md](./CONTRIBUTING.md).


## ❤️ Crediti

Major dependencies:
* [pyowm](https://github.com/csparpa/pyowm)
* [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)
* [hyperion](https://github.com/hyperion-project/hyperion)
* [node-hyperion-client](https://github.com/WeeJeWel/node-hyperion-client)
* [play-on-kodi](https://github.com/ritiek/play-on-kodi)


Il seguente utente è stato fonte di ispirazione: [7h30n3 (The One)](https://github.com/7h30n3) <3


## 💵 Supportami!

 [![ko-fi](https://www.ko-fi.com/img/donate_sm.png)](https://ko-fi.com/Y8Y0FW3V)



## 🗓️ Release History

* 0.1.0 - beta release


## 🎓 Licenza

[MIT](http://webpro.mit-license.org/)



