import os
from time import sleep
import RPi.GPIO as GPIO

""" Define some variables """
pin = 26  # pin ID, edit here to change it
max_TEMP = 70  # Temperature in Celsius after which the fan triggers
cutoff_TEMP = 60  # Temerature in Celsius after which the fan stops


def setup():
    """ Raspberry Pi GPIO setup """
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(pin, GPIO.OUT)
    return()


def getCPUtemperature():
    """ Get CPU temperature """
    res = os.popen('vcgencmd measure_temp').readline()
    temp = (res.replace("temp=", "").replace("'C\n", ""))
    # print("temp is {0}".format(temp))  # Uncomment here for testing
    return temp


try:
    setup()
    """ Manage the fan """
    while True:
        CPU_temp = float(getCPUtemperature())
        if (CPU_temp > max_TEMP):
            GPIO.output(pin, True)
            # print ("ON")
        if (CPU_temp < cutoff_TEMP):
            GPIO.output(pin, False)
            # print ("OFF")
        sleep(60)  # Read temperature every 60 sec, edit here to change it
except KeyboardInterrupt:
    GPIO.cleanup()  # clean up GPIO on CTRL+C exit
