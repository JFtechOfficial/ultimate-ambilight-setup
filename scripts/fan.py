import os
import json
from time import sleep
import RPi.GPIO as GPIO

""" Define some variables """
# Here you can find some pre-made fan profiles
# Uncomment only one profile to use it as default. Edit values as you like
# The fan.json config file will override these profiles
""" Conservative profile """
profile = {
    'max_TEMP': 70,  # Temperature in Celsius after which the fan triggers
    'cutoff_TEMP': 60,  # Temerature in Celsius after which the fan stops
    'sleepTime': 60  # Temperature reading interval in seconds
}

""" Aggressive profile """
"""
profile = {
    'max_TEMP': 60,  # Temperature in Celsius after which the fan triggers
    'cutoff_TEMP': 45,  # Temerature in Celsius after which the fan stops
    'sleepTime': 1  # Temperature reading interval in seconds
}
"""

""" Always ON profile """
"""
profile = {
    'max_TEMP': 10,  # Temperature in Celsius after which the fan triggers
    'cutoff_TEMP': 1,  # Temerature in Celsius after which the fan stops
    'sleepTime': 1000  # Temperature reading interval in seconds
}
"""

pin = 26  # pin ID (BCM), edit here to change the default value


def setup():
    """Raspberry Pi GPIO setup."""
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(pin, GPIO.OUT)
    return()


def getCPUtemperature():
    """Measure CPU temperature."""
    res = os.popen('vcgencmd measure_temp').readline()
    temp = (res.replace("temp=", "").replace("'C\n", ""))
    # print("temp is {0}".format(temp))  # Uncomment here for testing
    return temp


def fanManager():
     """Manage the fan."""
    while True:
        CPU_temp = float(getCPUtemperature())
        if (CPU_temp > profile["max_TEMP"]):
            GPIO.output(pin, True)
            # print ("ON")  # Uncomment here for testing
        if (CPU_temp < profile["cutoff_TEMP"]):
            GPIO.output(pin, False)
            # print ("OFF")  # Uncomment here for testing
        sleep(profile["sleepTime"])

        
try:
    setup()
    with open('fan.json') as f:
    data = json.load(f)
    pin = data['args']['pin']
    mode = data['args']['mode']
    if mode == 'AlwaysON':
        GPIO.output(pin, True)
    elif mode == 'Auto':
        settings = data['args']['settings']
        for name in settings:
            profile.update({name: settings[name]})
        fanManager()
    else:
        GPIO.output(pin, False)
except KeyboardInterrupt:
    GPIO.cleanup()  # clean up GPIO on CTRL+C exit
