# import json
import commentjson
import os
import subprocess
import time
import RPi.GPIO as GPIO

"""
Define some variables editing the button.json config file
(please do NOT use pin 5 (BOARD): it must be used as shutdown button)
"""
with open('buttons.json') as f:
    data = commentjson.load(f)
    clear = data['args']['clear']  # Pin ID
    effects = data['args']['effects']
    pins = {}  # {Pin ID: 'Effect name'}
    for name in effects:
        pins.update({effects[name]: name})

FNULL = open(os.devnull, 'w')


def launch(*args):
    """Call hyperion-remote."""
    if len(args) == 1:
        subprocess.call(['hyperion-remote', '--clearall'], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)
    if len(args) == 3:
        subprocess.call(['hyperion-remote', str(args[0]), str(args[1]), '--priority', str(args[2])], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)


def Effect(channel):
    """Start an effect."""
    launch('-e', pins[channel])


def Clear(channel):
    """Clear all effects (short press) or set color to black (long press)."""
    start = time.time()
    stop = start
    while GPIO.input(channel) == GPIO.LOW:
        time.sleep(0.01)
        stop = time.time() - start
        if stop > 1:
            with open('/etc/hyperion/hyperion.config.json') as config:
                data = commentjson.load(config)
            priority = data['grabber-v4l2']['priority']
            # print(priority)
            launch('--clearall')
            launch('--color', '000000', priority + 1)
            return
    print(stop)
    if stop > 0.02:
        launch('--clearall')


def setup():
    """Raspberry Pi GPIO setup."""
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(3, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    for key in pins:
        GPIO.setup(key, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        GPIO.add_event_detect(key, GPIO.FALLING, callback=Effect, bouncetime=300)
    GPIO.setup(clear, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.add_event_detect(clear, GPIO.FALLING, callback=Clear, bouncetime=300)


setup()
""" Waiting for shutdown button """
try:
    GPIO.wait_for_edge(3, GPIO.FALLING)
    launch('--clearall')
    GPIO.cleanup()
    time.sleep(1)
    subprocess.call(['shutdown', '-h', 'now'], shell=False)

except KeyboardInterrupt:
    GPIO.cleanup()  # clean up GPIO on CTRL+C exit
