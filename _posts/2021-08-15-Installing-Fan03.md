---
layout: post
title: 'Installing a Sonoff FAN03 and integrating with OpenHab'
categories:
- blog
tags: 
- lego
- fll
- 
excerpt: Sonoff FAN03
---

# Installation

After having some success with Sonoff devices, I bought a FAN03 to integrate into a bedroom.

The flashing process was straight forward after removing the case and soldering headers to the `Vcc`, `Tx`, `Rx` and `Gnd` pins.

![Scripts folder](/assets/img//blog/20210815-fan03/tasmota.jpg)

Next was to install it into the ceiling canopy, except space proved too tight. The FAN03 didn't fit into the hanger bracket. I thought I might be able to shove it up into the ceiling but the hole for the cable was too small.

![Scripts folder](/assets/img//blog/20210815-fan03/ceiling.jpg)

So decided to install it into space behind the wall plate.

First job was to understand and map out the existing wiring so a rollback was possible. Neutral and Earth are omitted as they are all terminated together anyway.

![Scripts folder](/assets/img//blog/20210815-fan03/old-wiring.png)

Taking photos helps too

![Scripts folder](/assets/img//blog/20210815-fan03/before-wallplate.jpg)

I wired in the FAN03 downstream of the wall plate switch so that in the event of a Raspberry Pi/OpenHab outage, the light could be turned off.
The existing speed control needs to be removed from the circuit as we will be using the FAN03's in built one.

So the new diagram is like

![Scripts folder](/assets/img//blog/20210815-fan03/new-wiring.png)

# Configuration

Time to switch the light circuit back on and watch for the DHCP lease to get the new IP assigned to Tasmota since I forgot to record that earlier.

## Sonoff

Using the webconsole, set the hostname and MQTT topic (MQTT hostname and creds not shown)

```
hostname sonoff_masterbed
topic bedmaster
```

Now if the wallswitch off and then someone walks in and wants light, they will turn the light on at the switch expecting the light to come on.

So define a rule to do this at start up, enable it and restart saving the settings.

```

PowerOnState 0
rule1 on Power1#boot do backlog fanspeed 0; power1 1 endon
Rule1 1
Restart 1

``` 

## OpenHab

Define a Thing

* The transform map is to map the 1,2,3 values to ON/OFF for the switch

```

  Thing topic bedmaster "Master Bedroom" @ "Bedroom" { 
    Channels:
      Type switch   : PowerSwitch "Button"  [stateTopic="stat/bedmaster/POWER" , commandTopic="cmnd/bedmaster/POWER1", on="ON", off="OFF"]
      Type number   : FanSpeed "Fan"        [stateTopic="stat/bedmaster/RESULT", transformationPattern="JSONPATH:$.FanSpeed", commandTopic="cmnd/bedmaster/FanSpeed"]
      Type switch   : FanSwitch "Fan"       [stateTopic="stat/bedmaster/RESULT", transformationPattern="JSONPATH:$.FanSpeed", commandTopic="cmnd/bedmaster/FanSpeed", profile="transform:MAP", function="fan03.map"]
  }

```

Define the Items

* TODO: I have named these poorly for automatic Homekit allocation to the correct room
* The switch type is present as it is required for Homekit integration


```

Switch light_bed_master      "Bedroom [%s]"     <lightbulb>   (g_upstairs)  { channel="mqtt:topic:PiMqttBroker:bedmaster:PowerSwitch", homekit="Lighting" }
Number fan_bed_master        "Fan"              <fan_ceiling> (gFanBedroom) { channel="mqtt:topic:PiMqttBroker:bedmaster:FanSpeed"}
Switch switch_fan_bed_master "Fan"              <fan_ceiling> (gFanBedroom) { channel="mqtt:topic:PiMqttBroker:bedmaster:FanSwitch", homekit="Fan"  }

```

and then define the sitemap for BasicUI

```
    Frame label="Bedroom" {   
            Switch item=light_bed_master label="Light"
            Switch item=fan_bed_master label="Fan" mappings=[0="Off", 1="Slow", 2="Med", 3="High"]
    }
```

All done, I can now ask Siri to turn my lights off at night.

---