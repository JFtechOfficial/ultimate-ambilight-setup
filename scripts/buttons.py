#import json
import commentjson
import os
import subprocess
import time
import RPi.GPIO as GPIO

"""
Define some variables editing the button.json config file
please do NOT use pin 5 (BOARD): it must be used as power button
"""
with open('buttons.json') as f:
    data = commentjson.load(f)
gpio_setup = data['args']['gpio-setup']
priority = data['args']['priority']
if not priority:
    priority = 100
with open('/etc/hyperion/hyperion.config.json') as config:
    hyperion_data = commentjson.load(config)

FNULL = open(os.devnull, 'w')


def launch(*args):
    """Call hyperion-remote."""
    if len(args) == 1:
        subprocess.call(['hyperion-remote', '--clearall'], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)
    if len(args) == 3:
        subprocess.call(['hyperion-remote', str(args[0]), str(args[1]), '--priority', str(args[2])], shell=False, stdout=FNULL, stderr=subprocess.STDOUT)
    
    
def effect(name, priority):
    """Start an effect."""
    launch('-e', name, priority)


def color(rgb_color, priority):
    """Start a color."""
    hex_color = '%02x%02x%02x' % tuple(rgb_color)
    launch('--color', hex_color, priority)


def clear_all():
    """Clear all effects/colors."""
    launch('--clearall')


def button_press(channel, duration):
    """Route button press."""
    pin = str(channel)
    on_press = gpio_setup[pin][duration]
    if isinstance(on_press, list):
        if duration == 'long-press' and gpio_setup[pin]['short-press'] == 'clear':
            clear_all()
            color(on_press, hyperion_data['grabber-v4l2']['priority'])
        else:
            color(on_press, priority)
    elif isinstance(on_press, str):
        if on_press == 'clear':
            clear_all()
        else:
            effect(on_press, priority)


def is_long_press(channel):
    """Detect long button press or short button press."""
    start = time.time()
    stop = start
    while GPIO.input(channel) == GPIO.LOW:
        time.sleep(0.01)
        stop = time.time() - start
        if stop > 1:
            button_press(channel, 'long-press')
            return
    if stop > 0.02:
        button_press(channel, 'short-press')


def setup():
    """Raspberry Pi GPIO setup."""
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    power_button = 3
    if data['args']['gpio-mode'] == 'BOARD':
        GPIO.setmode(GPIO.BOARD)
        power_button = 5
    GPIO.setup(power_button, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    for pin in gpio_setup:
        GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        pin_setup = gpio_setup[pin]
        if pin_setup['short-press'] or pin_setup['long-press']:
            GPIO.add_event_detect(int(pin), GPIO.FALLING, callback=islongpress, bouncetime=300)
    

setup()
""" Waiting for shutdown button """
try:
    GPIO.wait_for_edge(power_button, GPIO.FALLING)
    launch('--clearall')
    GPIO.cleanup()
    time.sleep(1)
    subprocess.call(['shutdown', '-h', 'now'], shell=False)
except KeyboardInterrupt:
    GPIO.cleanup()
