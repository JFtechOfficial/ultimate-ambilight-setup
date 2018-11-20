import time
from datetime import datetime
import geocoder
import hyperion
import pyowm


def myRange(index, margin):
    """Define the range."""
    return [i % hyperion.ledCount for i in range(index - margin, index + margin + 1)]


def myTemp(lat, long):
    """Define color based on temperature."""
    temperature = owm.weather_at_coords(lat, long).get_weather().get_temperature('celsius')['temp']
    color = (0, 0, 255)

    if temperature <= 1:
        color = (0, 72, 255)

    if temperature > 1 and temperature <= 12:
        color = (10, 255, 236)

    if temperature > 12 and temperature <= 23:
        color = (20, 255, 52)

    if temperature > 23 and temperature <= 34:
        color = (255, 250, 10)    # (178, 255, 30) is the mathematical gradient

    if temperature > 34 and temperature <= 45:
        color = (255, 158, 40)

    return color


""" Define some variables """
sleepTime = 1

ledCount = hyperion.ledCount

offset = hyperion.args.get('offset', 0)

direction = bool(hyperion.args.get('direction', False))
counterclock = 0
if direction:
    counterclock = ledCount

hourMargin = hyperion.args.get('hour-margin', 2)
minuteMargin = hyperion.args.get('minute-margin', 1)
secondMargin = hyperion.args.get('second-margin', 0)

hourColor = hyperion.args.get('hour-color', (255, 0, 0))
minuteColor = hyperion.args.get('minute-color', (0, 255, 0))
secondColor = hyperion.args.get('second-color', (0, 0, 255))

latitude = hyperion.args.get('latitude', None)
longitude = hyperion.args.get('longitude', None)
if not (latitude or longitude):
    g = geocoder.ipinfo('me')
    if g.latlng:
        latitude = g.latlng[0]
        longitude = g.latlng[1]

owmWait = 0
owmAPIkey = hyperion.args.get('owmAPIkey', '')
if owmAPIkey != '':
    owm = pyowm.OWM(owmAPIkey)  # You MUST provide a valid API key
    secondColor = myTemp(latitude, longitude)

marker = ledCount / 4
markers = [0 + offset, int(marker + offset) % ledCount, int(2 * marker + offset) % ledCount, int(3 * marker + offset) % ledCount]
markerColor = hyperion.args.get('marker-color', (255, 255, 255))

""" The effect loop """
while not hyperion.abort():

    led_data = bytearray()

    now = datetime.now()
    h = now.hour
    m = now.minute
    s = now.second

    hmin = float(h + (1 / 60 * m))

    if hmin > 12:
        hmin -= 12

    hour = float(hmin / 12 * ledCount)
    led_hour = int(abs(counterclock - hour) + offset) % ledCount

    minute = m / 60. * ledCount
    led_minute = int(abs(counterclock - minute) + offset) % ledCount

    second = s / 60. * ledCount
    led_second = int(abs(counterclock - second) + offset) % ledCount

    hourRange = myRange(led_hour, hourMargin)
    minuteRange = myRange(led_minute, minuteMargin)
    secondRange = myRange(led_second, secondMargin)

    if owmWait >= 600 and owmAPIkey:
        secondColor = myTemp(latitude, longitude)
        owmWait = 0

    else:
        owmWait += 1

    for i in range(ledCount):
        blend = [0, 0, 0]

        if i in markers:
            blend = markerColor

        if i in hourRange:
            blend = hourColor

        if i in minuteRange:
            blend = minuteColor

        if i in secondRange:
            blend = secondColor

        led_data += bytearray((int(blend[0]), int(blend[1]), int(blend[2])))

    """ send the data to hyperion """
    hyperion.setColor(led_data)

    """ sleep for a while """
    timediff = (datetime.now() - now).microseconds / 1000000.
    time.sleep(sleepTime - timediff)
