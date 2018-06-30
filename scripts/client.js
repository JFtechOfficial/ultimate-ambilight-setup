'use strict';

//requires
var mqtt = require('mqtt');
var Hyperion = require('hyperion-client');
var fs = require('fs');
var exec = require('child_process').exec;

//reading json config file
fs.readFile('./client.json', 'utf8', function(err, data) {
  if (err) console.error('err -> ', err);
  var obj = JSON.parse(data);

  //variables
  var config = obj.args;
  var hyperion_ip_address = String(config.hyperion_server.ip_address) || '127.0.0.1';
  var hyperion_port = config.hyperion_server.port || 19444;
  var url = config.adafruit_mqtt_broker.url || 'mqtts://io.adafruit.com';
  var user = config.adafruit_mqtt_broker.username;
  var options = {
    port: config.adafruit_mqtt_broker.port || 8883,
    username: user,
    password: config.adafruit_mqtt_broker.key
  };
  var topics = config.adafruit_mqtt_broker.topics;

  var kodi_ip_address = config.kodi_server.ip_address || '127.0.0.1';
  var kodi_port = config.kodi_server.port || 8080;
  var uri = config.kodi_server.video_uri || 'https://youtu.be/dQw4w9WgXcQ';


  //mqtt client
  var client = mqtt.connect(url, options);

  client.on('connect', function() {
    Object.keys(topics).forEach(function(topic) {
      if (topics[topic]) {
        client.subscribe(user + '/feeds/' + topics[topic]);
        //console.log('sub', user + '/feeds/' + topics[topic]);
      }
    });
    //client.publish('username/feeds/hyperion-effects', 'Snake');
    //console.log('pub username/feeds/hyperion-effects  Snake');
  });

  client.on('message', function(topic, message) {
    //console.log('effect: ', message.toString());

    //hyperion client
    var hyperion = new Hyperion(hyperion_ip_address, hyperion_port);
    hyperion.on('connect', function() {
      //console.log('connected');

      //effects
      if (topic == user + '/feeds/' + topics.effect_topic) {
        hyperion.getServerinfo(function(err, result) {
          for (var e in result.info.effects) {
            var effect = String(result.info.effects[e].name);
            if (String(message).toLowerCase() == effect.toLowerCase()) {
              hyperion.setEffect(effect, {}, function(err, result) {
                //console.log('err', err, 'result', result);
                hyperion.close();
              });
            }
          }
        });
      }

      //clear effect and custom stuff
      else if (topic == user + '/feeds/' + topics.other_topic) {
        if (message == 'OFF') {
          hyperion.clearall(function(err, result) {
            //console.log('err', err, 'result', result);
            hyperion.close();
          });
        }

        //custom effect launcher - turn on the lights
        if (message == 'ON') {
          hyperion.setEffect('Cinema dim lights', {}, function(err, result) {
            //console.log('err', err, 'result', result);
            hyperion.close();
          });
        }
        //play a video with capture mode - "fireplace mode"
        if (message == 'PLAY') {
          hyperion.clearall(function(err, result) {
            //console.log('err', err, 'result', result);
            exec('playonkodi -s ' + kodi_ip_address + ' -p ' + kodi_port + ' ' + uri);
            hyperion.close();
          });
        }

        if (message == 'STOP') {
          hyperion.clear(function(err, result) {
            //console.log('err', err, 'result', result);
            exec('playonkodi -s ' + kodi_ip_address + ' -p ' + kodi_port + ' https://youtu.be/Mvvsa5HAJiI');
            hyperion.close();
          });
        }
      } else {
        hyperion.close();
      }

    });

    hyperion.on('error', function(error) {
      console.log('error-> ', error);
    });
  });

  //client.end();

  client.on('error', function(error) {
    console.error('error:', error);
  });
});
