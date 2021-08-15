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

Next was to install it into the ceiling canopy, except space proved too tight. The FAN03 didn't fit into the hanger bracket. I thought I might be able to shove it up into the ceiling but the hole was only big enough for the cable.

![Scripts folder](/assets/img//blog/20210815-fan03/ceiling.jpg)

I ordered a Plasterboard jab saw but realised I could install it into space behind the wall plate.

First job was to understand and map out the existing wiring so a rollback was possible. Neutral and Earth are omitted as they are all terminated together anyway.

![Scripts folder](/assets/img//blog/20210815-fan03/old-wiring.png)

Taking photos helps too

![Scripts folder](/assets/img//blog/20210815-fan03/before-wallplate.jpg)

I wired in the FAN03 downstream of the wall plate switch so that in the event of a Raspberry Pi/OpenHab outage, the light could be turned off.
The existing speed control needs to be removed from the circuit as we will be using the FAN03's in built one.

So the new circuit is much simpler

![Scripts folder](/assets/img//blog/20210815-fan03/new-wiring.png)

The old dimmer mech is still there, replacing the wallplate is a `TODO` job for later

![Scripts folder](/assets/img//blog/20210815-fan03/after-wiring.jpg)

# Configuration

Time to switch the light circuit back on and watch for the DHCP lease to get the new IP assigned to Tasmota since I forgot to record that earlier.

## Sonoff

Using the webconsole, set the hostname and MQTT topic (Setting MQTT hostname and creds not shown)

```
hostname sonoff_masterbed
topic bedmaster
```

Now if the wallswitch is off (and SONOFF too) then someone turns the switch onthey will expect the light to come on.

So define a Tasmota rule to do this at boot, enable it and restart saving the settings.

```

PowerOnState 0
rule1 on Power1#boot do backlog fanspeed 0; power1 1 endon
Rule1 1
Restart 1

``` 

## OpenHab

### Define a Thing

* The transform map is to map the 1,2,3 values to ON/OFF for the switch

```

  Thing topic bedmaster "Master Bedroom" @ "Bedroom" { 
    Channels:
      Type switch   : PowerSwitch "Button"  [stateTopic="stat/bedmaster/POWER" , commandTopic="cmnd/bedmaster/POWER1", on="ON", off="OFF"]
      Type number   : FanSpeed "Fan"        [stateTopic="stat/bedmaster/RESULT", transformationPattern="JSONPATH:$.FanSpeed", commandTopic="cmnd/bedmaster/FanSpeed"]
      Type switch   : FanSwitch "Fan"       [stateTopic="stat/bedmaster/RESULT", transformationPattern="JSONPATH:$.FanSpeed", commandTopic="cmnd/bedmaster/FanSpeed", profile="transform:MAP", function="fan03.map"]
  }

```

### Define the Items

* TODO: I have named these poorly for automatic Homekit allocation to the correct room
* The `Switch switch_fan_bed_master` is present as it is required for the Apple Homekit integration


```

Switch light_bed_master      "Bedroom [%s]"     <lightbulb>   (g_upstairs)  { channel="mqtt:topic:PiMqttBroker:bedmaster:PowerSwitch", homekit="Lighting" }
Number fan_bed_master        "Fan"              <fan_ceiling> (gFanBedroom) { channel="mqtt:topic:PiMqttBroker:bedmaster:FanSpeed"}
Switch switch_fan_bed_master "Fan"              <fan_ceiling> (gFanBedroom) { channel="mqtt:topic:PiMqttBroker:bedmaster:FanSwitch", homekit="Fan"  }

```

### Basic UI Sitemap


```
    Frame label="Bedroom" {   
            Switch item=light_bed_master label="Light"
            Switch item=fan_bed_master label="Fan" mappings=[0="Off", 1="Slow", 2="Med", 3="High"]
    }
```

> Hey Siri, turn on the bedroom light!

![Scripts folder](/assets/img//blog/20210815-fan03/siri.png)

---