'use strict';

//requires
var mqtt = require('mqtt');
var Hyperion = require('hyperion-client');
var fs = require('fs');

//reading json config file
fs.readFile('./client.json', 'utf8', function(err, data) {
  if (err) console.error('err -> ', err);
  var obj = JSON.parse(data);

  var hyperion_ip = String(obj.args.hyperion_server.ip_address);
  var hyperion_port = obj.args.hyperion_server.port;
  var url = obj.args.adafruit_mqtt_broker.url;
  var user = obj.args.adafruit_mqtt_broker.username;
  var options = {
    port: obj.args.adafruit_mqtt_broker.port,
    username: user,
    password: obj.args.adafruit_mqtt_broker.key
  };
  var topics = obj.args.adafruit_mqtt_broker.topics;

  //hyperion client
  var hyperion = new Hyperion(hyperion_ip, hyperion_port);
  hyperion.on('connect', function() {
    console.log('connected');
  });

  hyperion.on('error', function(error) {
    console.error('error-> ', error);
  });

  //mqtt client
  var client = mqtt.connect(url, options);

  client.on('connect', function() {
    topics.forEach(function(element) {
      client.subscribe(user + '/feeds/' + element);
      console.log('sub', user + '/feeds/' + element);
    });

    //client.publish('jhonfreddo/feeds/hyperion-effect', 'Snake');
    //console.log('pub');
  });

  client.on('message', function(topic, message) {
    console.log(topic);
    console.log('effect: ', message.toString());
    hyperion.getServerinfo(function(err, result) {
      for (var e in result.info.effects) {
        var effect = String(result.info.effects[e].name);
        if (String(message).toLowerCase() == effect.toLowerCase()) {
          hyperion.setEffect(effect, {}, function(err, result) {
            //console.log('erro', err, 'result', result);
          });
        }
      }
    });
  });

  //client.end();

  client.on('error', function(error) {
    console.error('error:', error);
  });
});
