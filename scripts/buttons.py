import os
import subprocess
from time import sleep
import RPi.GPIO as GPIO

""" Define some variables (do NOT use pin 3, it's hardcoded as shutdown button) """
pins = {17: 'Rainbow swirl fast', 22: 'Clock'}   # Pin ID: 'Effect name', edit here to change or add pins
clear = 27  # Pin ID, edit here to change it

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
    sleep(5)
    subprocess.call(['shutdown', '-h', 'now'], shell=False)

except KeyboardInterrupt:
    GPIO.cleanup()  # clean up GPIO on CTRL+C exit
