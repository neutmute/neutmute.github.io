---
layout: post
title: 'Control an IKEA Praktlysing Blind with OpenHAB using Zigbee2MQTT'
categories:
  blog
excerpt: Using Zigbee2MQTT to control an IKEA Praktlysing blind from OpenHab
---

   
The IKEA Praktlysing blind is part of the smart home range from IKEA. This is how I connected it to OpenHAB _without_ using the Tradfri gateway.

# Binding

Out of the box, the blind and remote worked fine. Trying to join it to my Zigbee mesh was was very frustrating though. These were the final steps used after many factory resets (maybe a factory reset is needed beforehand).

1. Put Zigbee2MQTT into `Permit Join` mode
2. Repater: Press reset pin for 5 seconds+. The light does not change at all
    1. Wait for Zigbee2MQTT to interview device and confirm
    1. The Repeater is now open for 2 minutes to join the blind and remote, so keep going with the next steps straight after.
3. Remote: Press pairing button 4x. It starts flashing red, does it's thing and joins.
4. Blind: Hold both buttons for 5 seconds until the LED comes on.
    1. Hold the blind near the repeater

This was pretty much what the documentation says but it took a lot of goes to get it right.
After the above, the remote controls the blind, but does not show any MQTT messages on Zigbee2MQTT. 

At one stage I joined the remote direct to Zigbee2MQTT's adapter and not the repeater, at that point the MQTT messages were visible and could be used to trigger different events than the blind say - but it didn't control the blind directly. This could be done using OpenHAB to orchestrate but it's more complication than I need.

If everything has gone right, the Zigbee2MQTT Map should show the repeater connected to to the controller and the blind and remote connected by dashes to the repeater.

# Zigbee2MQTT

For the purposes of below, setup the friendly name of the blind as `zb-hallway-blind`

# OpenHAB

My final configurations

## Thing

```
Bridge mqtt:broker:PiMqttBroker [ host="192.168.xx.xx", secure=false, username="openhabian", password="xxxxx"] {
  Thing topic zigbee "Zigbee Bridge" @ "Sonoff" {   
    Channels:

     Type number : HallwayBlindPosition [stateTopic="zigbee2mqtt/zb-hallway-blind",  transformationPattern="JSONPATH:$.position"]

  }
```

I have a `thing` defined and it was working at one stage - receiving messages from the blind state although for some reason in the final setup after numerous resets and rebindings it doesn't work. This doesn't matter to me as I only want to control the blind, not read its state.


## Items

```
Number blind_hallway_number "Hallway Blind Read" { channel="mqtt:topic:PiMqttBroker:zigbee:HallwayBlindPosition"   } // Not used as the thing isn't updating??
Rollershutter blind_hallway_proxy "Hallway Blind" 
```

## Rule - Manual Control

Building a JSON payload as per [zigbee2mqtt.io](https://www.zigbee2mqtt.io/devices/E2102.html).

Because I wanted to send a state and not a position, this seemed the best way, sending the MQTT message direct from the rule.

```
rule "Hallway Blind Command"
when
    Item blind_hallway_proxy received command 
then "value"
     
    logInfo("Blind", String::format("Shutter Blind command=%s", receivedCommand))

    val mqttActions = getActions("mqtt","mqtt:broker:PiMqttBroker")
    val blindTopic = "zigbee2mqtt/zb-hallway-blind/set"
    val newState = "STOP"

    switch(receivedCommand) 
    {
        case STOP:
        {
            newState = "STOP"
        } 
        case UP:
        {
            newState = "OPEN"
        }
        case DOWN:
        {
            newState = "CLOSE"
        }
    }

    val commandJson = String::format("{\"state\": \"%s\"}", newState)
    
    logInfo("Blind", String::format("Rule is publishing %s", commandJson))

    mqttActions.publishMQTT(blindTopic, commandJson)

end
```

## Sitemap

Surface a manual control for the blind

```
    Frame label="Upstairs" {   
            Default item=blind_hallway_proxy
    }
```

## Rule - Automatic Sun Blocking

Untested at the time of writing but theoretically sends the blind down when the Western sun hits the window and then raises it after

```
rule "Hallway Blind Down"
when 
	
	Time cron "0 0 13 ? * * *"
then    
    logInfo("scheduleRule", "Blind down")
    
    blind_hallway_proxy.sendCommand(DOWN)
end


rule "Hallway Blind Up"
when 
	
	Time cron "0 0 17 ? * * *"
then    
    logInfo("scheduleRule", "Blind up")
    
    blind_hallway_proxy.sendCommand(UP)
end

```