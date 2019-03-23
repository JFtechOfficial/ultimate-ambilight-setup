[![banner](https://dl.dropboxusercontent.com/s/xbczn9daprt7q2i/banner.png?dl=0 "banner with JFtech logo & social")](https://linktr.ee/jftechofficial)
[![Raspberry Pi](https://img.shields.io/badge/made%20for-Raspberry%20Pi-red.svg)](https://www.raspberrypi.org) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) ![license](https://img.shields.io/github/license/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub issues](https://img.shields.io/github/issues/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/JFtechOfficial/ultimate-ambilght-setup.svg) ![GitHub top language](https://img.shields.io/github/languages/top/JFtechOfficial/ultimate-ambilght-setup.svg) ![Requires.io](https://img.shields.io/requires/github/JFtechOfficial/ultimate-ambilght-setup.svg)

Scripts che ho creato per migliorare l'esperienza con Hyperion. You can also read this in [English:gb:](README.md)


## 🚀 Getting started

<details>
 <summary><strong>Lista dei Contenuti</strong> (clicca per espandere)</summary>

* [Getting started](#-getting-started)
* [Installazione](#-installazione)
* [Configurazione](#️-configurazione)
* [Uso](#️-uso)
* [Risorse](#-risorse)
* [Contribuire](#-contribuire)
* [Crediti](#️-crediti)
* [Supportami!](#-supportami)
* [FAQ](#-faq)
* [Release History](#️-release-history)
* [Licenza](#-licenza)
</details>

### Requisiti
* Un Raspberry Pi 2, 3 o [3+](https://amzn.to/2Kx4ABj)
* Una [microSD](https://amzn.to/2Kw6YZ0) con un OS installato e pronto all'uso, è consigliato [OSMC](https://osmc.tv/download/) (tutorial: [come installare OSMC](https://youtu.be/cdpQa52AK0w))

Assicurati di avere [Hyperion](https://hyperion-project.org) installato e configurato (è consigliata l'installazione e la configurazione via [HyperCon](https://hyperion-project.org/wiki/HyperCon-Information)).


## 💾 Installazione
* Apri una finestra del terminale sul tuo Raspberry Pi o connettiti via SSH (usa l'app Terminale su MacOS/Linux, o scarica [PuTTY](https://www.putty.org) su Windows) e esegui questo comando per clonare questa repository sul tuo dispositivo:
```shell
cd ~/ && sudo apt-get install git && git clone https://github.com/JFtechOfficial/ultimate-ambilight-setup.git
```
* Se vuoi puoi [pre-configurare](#️-configurazione) gli [effetti di Hyperion](#effetto-orologio) e lo [script dei pulsanti](#pulsanti). Li puoi trovare nelle seguenti cartelle: `Hyperion_effects`, `buttons`.

 * Esegui lo script di installazione:
```shell
cd  ~/ultimate-ambilight-setup/
sudo chmod 775 install.sh
sudo ./install.sh
```

* Puoi decidere cosa installare usando le opzioni `-a`, `-b`, `-c` e `-f` (nessuna opzione di installazione personalizzata significa "installa tutto").
```shell
Opzioni:
    Opzioni generali:
        -h --help           Mostra questa schermata.
        -v --version        Mostra versione.
    Opzioni di installazione personalizzata:
        -a --assistant      Installa lo script per Google Assistant.
        -b --buttons        Installa lo script per i pulsanti.
        -c --clock          Installa l'effetto orologio.
        -f --fan            Installa lo script per la ventola.
```
* Puoi ora [configurare](#️-configurazione) tutti i file .json, inclusi quelli per [lo script di Google Assistant](#google-assistant) e quello per lo [script della ventola](#ventola). Li puoi trovare nelle seguenti cartelle: `hyperion-mqtt-subscriber`, `Raspberry-Pi-PWM-fan`.


## ⚙️ Configurazione
Puoi anche cambiare qualsiasi valore di configurazione dopo il processo di [installazione](#-installazione). Se lo fai, ricordati di riavviare il sistema:
```shell
sudo reboot
```

### Effetto Orologio
* Ottieni [la tua API key di OpenWeatherMap](http://openweathermap.org/appid) 
* Apri il file `clock.json` :
```shell
sudo nano ~/ultimate-ambilight-setup/Hyperion_effects/clock.json
```
* Modifica il valore di `owmAPIkey` incollando la tua API key (puoi usare la stessa API key nell'app Meteo di Kodi)
* Ottieni [le tue coordinate](https://gps-coordinates.org) 
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
*  Modifica i valori di `effects` e `clear` per farli combaciare con il setup dei tuoi pin di GPIO. EVITA di usare il pin 3 (BCM) a.k.a. GPIO 5 (BOARD) per qualsiasi  scopo diverso dal pulsante di accensione/spegnimento: è già stato hardcoded per te in questa maniera e non può essere cambiato per motivi legati all'hardware. Per questo motivo NON devi configurarlo nel file `buttons.json`.
* Modifica i valori di `short-press` e `long-press` per ogni pin. Puoi assegnare il nome di un effetto (es. `"Rainbow swirl"`) per lanciare il suddetto effetto, un valore RGB (es. `[255,0,0]`) per lanciare il colore risultante, la stringa `"clear"` per tornare alla modalità di cattura di default, oppure `null` per non fare nulla. 

*Personalmente suggerisco di non modificare:*
```
{
"short-press" : "clear",
"long-press" : [0,0,0]
}
```

* Puoi aggiungere quanti pulsanti vuoi incollando (e configurando) il seguente codice dopo `gpio-setup: {` :
```json
"Pin number" :
{
    "short-press" : "effect name"/[255,255,255]/null,
    "long-press" : "effect name"/[255,255,255]/null
},
```

* Modifica il valore di `gpio-mode` per farlo combaciare con quello usato per assegnare i numeri ai pin ("BCM"/"BOARD")
* Salva `Ctrl + X` e chiudi il file `Enter`

### Ventola
* Apri il file `fan.json` :
```shell
nano ~/ultimate-ambilight-setup/scripts/fan.json
```
* Modifica il valore di `pin` per farlo combaciare con il setup dei tuoi pin di GPIO
* Modifica il valore di `gpio-mode` per farlo combaciare con quello usato per assegnare i numeri ai pin ("BCM"/"BOARD")
* Puoi modificare gli altri valori per assicurarti che la ventola funzioni come dovrebbe
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
* Modifica il valore di `color-topic` dell' `adafruit_mqtt_broker` per farlo combaciare con il nome del tuo topic di Adafruit-IO per "laciare un colore"
* Modifica il valore di `misc-topic` dell' `adafruit_mqtt_broker`  per farlo combaciare con il nome del tuo topic di Adafruit-IO per "comandi misti"
* Modifica il valore di `ip_address` del `kodi_server` per farlo combaciare con l'indirizzo IP del dispositivo su cui è in esecuzione Kodi ("127.0.0.1" se è lo stesso dispositivo che fa girare lo script)
* Modifica il valore di `video_uri` del `kodi_server` con il percorso locale o il link da internet del video che vuoi riprodurre (supportati: YouTube, Dropbox, Flickr, GoogleDrive, Reddit, Twitch:video, Vimeo, VK e molti altri)
* Ottieni [la tua API key di Yandex](https://translate.yandex.com/developers/keys).
* Modifica il valore di `API_key` inserendo la tua API key di Yandex.
* Modifica il valore di `from_language` per farlo combaciare con la tua lingua (it per Italiano)
* Puoi aggiungere azioni personalizzate incollando il seguente codice dopo `"custom_actions": [` :
```json
{
"message": "your_message",
"target": "effect name"/[255,255,255]/"clear"/null
},
```
* Salva `Ctrl + X` e chiudi il file `Enter`


## ▶️ Uso

Usa il tuo [client di Hyperion](https://play.google.com/store/apps/details?id=nl.hyperion.hyperionfree&hl=it_IT) pereferito per selezionare e lanciare l'effetto orologio: la lancetta dei secondi avrà un colore più caldo quando fuori fa caldo e un colore più freddo quando fuori fa freddo.

Usa i pulsanti connessi al GPIO per avviare i gli effetti di Hyperion che hai predefinito, tornare alla modalità cattura, accendere o spegnere in maniera sicura il tuo Raspberry Pi. Puoi attivare diverse funzioni alla pressione e alla pressione prolungata.

Usa una ventola connessa al GPIO: comincerà a girare automaticamente  ea a raffreddare il sistema variando la sua velocità a seconda della temperatura della CPU del Raspberry Pi.

Usa [IFTTT](https://ifttt.com/) per interfacciare Google Assistant con il broker mqtt di Adafruit-IO. Puoi inviare:
* al topic di Adafruit-IO per "lanciare un effetto" *(lo stesso topic assegnato a* `effect-topic` *in precedenza)*
   * il nome di un effetto per lanciare quell'effetto
* al topic di Adafruit-IO per "lanciare un colore" *(lo stesso topic assegnato a* `color-topic` *in precedenza)*
   * il nome di un colore per lanciare quel colore
* al topic di Adafruit-IO per "comandi misti" *(lo stesso topic assegnato a* `misc-topic` *in precedenza)*
   * `OFF` per spegnere qualsiasi effetto/colore (torna alla modalità di cattura di default)
   * `ON` per accendere le luci di colore bianco (azione personalizzata)
   * `PLAY` per riprodurre il video da `video_uri` e contemporaneamente spegnere qualsiasi effetto (torna in modalità cattura)
   * `STOP` per interrompere qualsiasi video (torna alla modalità di cattura di default)

Ora puoi usare Google Assistant sul tuo smartphone/tablet/Google Home per dire a Hyperion cosa fare. 


## 📚 Risorse
Ecco una video guida passo-passo su come costruire l'ultimate Ambilight setup: 

[![YouTube-tutorial](https://img.youtube.com/vi/1jSvfTHL-Lc/0.jpg)](https://www.youtube.com/playlist?list=PLdofamVz_h4NEx3Nl7P7_7uFXKz59dCV5)

Puoi anche consultare la [wiki](https://github.com/JFtechOfficial/ultimate-ambilght-setup/wiki)

Il file `hyperion.config.json` è un esempio di un file di configurazione funzionante per Hyperion (generato via [HyperCon](https://github.com/hyperion-project/hypercon))

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


## 💵 Supportami!

 [![ko-fi](https://i.imgur.com/3MPSu8i.png)](https://ko-fi.com/Y8Y0FW3V)


## 💭 FAQ

> Posso usare lo stesso pin GPIO per la configurazione di due script differenti?

No. Non dovresti mai utilizzare lo stesso pin per tasks differenti allo stesso momento (es. controllare la ventola e contemporaneamente leggere lo stato di un pulsante dallo stesso pin non funzionerà e potrebbe danneggiare il Raspberry Pi).

> Posso installare lo script del client di Google Assistant su un Raspberry Pi differente da quello su cui è in esecuzione Hyperion?

Si. Puoi lasciarlo in esecuzione su una qualsiasi macchina unix connessa allo stesso network locale: invierà i comandi al Raspberry Pi che su cui è in esecuzione Hyperion. lo script della ventola, quello dei pulsanti e l'effetto orlologio non possono essere usati nella stessa maniera: devi installarli sulla macchina su cui intendi utilizzarli.


## 🗓️ Release History

* 06/09/2018 - 0.1.0 - beta release


## 🎓 Licenza

[MIT](http://webpro.mit-license.org/)



