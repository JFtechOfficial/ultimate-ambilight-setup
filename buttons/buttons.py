#import json
import commentjson
import os
import subprocess
import time
import RPi.GPIO as GPIO

"""
Define some variables editing the button.json config file
please don't use pin 5 (BOARD) aka gpio 3 (BCM): it must be used as power button
"""
with open('buttons.json') as f:
    data = commentjson.load(f)
gpio_setup = data['args']['gpio-setup']
prior = data['args']['priority']
if not prior:
    priority = 100
else:
    priority = int(prior)
with open('/etc/hyperion/hyperion.config.json') as config:
    hyperion_data = commentjson.load(config)

FNULL = open(os.devnull, 'w')
ignore = False


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
    elif on_press:
        if on_press == 'clear':
            clear_all()
        else:
            effect(on_press, priority)


def is_long_press(channel):
    """Detect long button press or short button press."""
    #print("PRESS")
    global ignore # Other buttons get triggered sometimes for no apparent reason. 
    #print("ignore: ", ignore)
    if ignore:
        return
    ignore = True
    start = time.time()
    stop = start
    while GPIO.input(channel) == GPIO.LOW:
        time.sleep(0.01)
        stop = time.time() - start
        if stop > 2:
            button_press(channel, 'long-press')
            break
    if stop > 0.03 and stop <= 2:
        button_press(channel, 'short-press')

    time.sleep(0.3)

    ignore = False
    #print("DONE")


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
        channel = int(pin)
        GPIO.setup(channel, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        pin_setup = gpio_setup[pin]
        if pin_setup['short-press'] or pin_setup['long-press']:
            GPIO.add_event_detect(channel, GPIO.FALLING, callback=is_long_press, bouncetime=300)
    return power_button


def shutdown():
    """Shutdown procedure."""
    GPIO.wait_for_edge(power_button, GPIO.FALLING)
    time.sleep(2)
    if GPIO.input(power_button) == GPIO.LOW:
        launch('--clearall')
        GPIO.cleanup()
        time.sleep(1)
        subprocess.call(['shutdown', '-h', 'now'], shell=False)
    else:
        shutdown()


power_button = setup()
""" Waiting for shutdown button """
try:
    shutdown()
except KeyboardInterrupt:
    GPIO.cleanup()
