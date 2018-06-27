import os
import subprocess
import json
from time import sleep
import RPi.GPIO as GPIO

""" Define some variables editing the button.json config file 
    (please do NOT use pin 3 (BCM): it must be used as shutdown button) """
with open('buttons.json') as f:
    data = json.load(f)
    f.close()
    clear = data['args']['clear']  # Pin ID
    effects = data['args']['effects']
    pins = {}  # {Pin ID: 'Effect name'}
    for name in effects:
        pins.update({effects[name] : name})
        
FNULL = open(os.devnull, 'w')


def Effect(channel):
    """ Start an effect """
    subprocess.call(['hyperion-remote', '-e', pins[channel]], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)


def Clear(channel):
    """ Clear all effects """
    subprocess.call(['hyperion-remote', '--clearall'], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)


def setup():
    """ Raspberry Pi GPIO setup """
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(3, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    for key in pins:
        GPIO.setup(key, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        GPIO.add_event_detect(key, GPIO.FALLING, callback=Effect, bouncetime=300)
    GPIO.setup(clear, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.add_event_detect(clear, GPIO.FALLING, callback=Clear, bouncetime=300)
    return()


setup()
""" Waiting for shutdown button """
try:
    GPIO.wait_for_edge(3, GPIO.FALLING)
    subprocess.call(['hyperion-remote', '--clearall'], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)
    GPIO.cleanup()
    sleep(2)
    subprocess.call(['shutdown', '-h', 'now'], shell=False)

except KeyboardInterrupt:
    GPIO.cleanup()  # clean up GPIO on CTRL+C exit
