import os
from time import sleep
import RPi.GPIO as GPIO

""" Define some variables """
pin = 26  # pin ID, edit here to change it

# Uncomment only one profile to use it. Edit values as you like
""" Conservative profile """
max_TEMP = 70  # Temperature in Celsius after which the fan triggers
cutoff_TEMP = 60  # Temerature in Celsius after which the fan stops
sleepTime = 60  # Temperature reading interval in seconds

""" Aggressive profile """
"""
max_TEMP = 60  # Temperature in Celsius after which the fan triggers
cutoff_TEMP = 45  # Temerature in Celsius after which the fan stops
sleepTime = 1  # Temperature reading interval in seconds
"""

""" Always ON profile """
"""
max_TEMP = 10  # Temperature in Celsius after which the fan triggers
cutoff_TEMP = 1  # Temerature in Celsius after which the fan stops
sleepTime = 100  # Temperature reading interval in seconds
"""


def setup():
    """ Raspberry Pi GPIO setup """
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(pin, GPIO.OUT)
    return()


def getCPUtemperature():
    """ Measure CPU temperature """
    res = os.popen('vcgencmd measure_temp').readline()
    temp = (res.replace("temp=", "").replace("'C\n", ""))
    print("temp is {0}".format(temp))  # Uncomment here for testing
    return temp


try:
    setup()
    """ Manage the fan """
    while True:
        CPU_temp = float(getCPUtemperature())
        if (CPU_temp > max_TEMP):
            GPIO.output(pin, True)
            # print ("ON")  # Uncomment here for testing
        if (CPU_temp < cutoff_TEMP):
            GPIO.output(pin, False)
            # print ("OFF")  # Uncomment here for testing
        sleep(sleepTime)
except KeyboardInterrupt:
    GPIO.cleanup()  # clean up GPIO on CTRL+C exit
