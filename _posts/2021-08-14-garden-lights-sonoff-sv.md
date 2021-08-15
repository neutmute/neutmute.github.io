---
layout: post
title: 'Using a Sonoff SV to control garden lights'
categories:
- blog
tags: 
- lego
- fll
- 
excerpt: Sonoff 
---

The front garden has some 12V lights that are turned off and on by a mechanical timer. Time to throw a Sonoff at it.

![Scripts folder](/assets/img//blog/20210814-garden-lights-sonoff/12vac-transformer.jpg)

The first thing to note is that this is a 12V **AC** transformer so we can't use the relay input to leech power for the Espy controller.

Following the [Sonoff wiki](https://wiki.iteadstudio.com/Sonoff_SV) I removed the two resistors to isolate the relay and prepared a USB cable with female breadboard connectors to supply 5V to the Espy.

The sheer thickness of the 12V garden cables was concerning so I beefed up the solder trace for the relay

![Scripts folder](/assets/img//blog/20210814-garden-lights-sonoff/sonoff-sv.jpg)

After stripping out some 240V wire from a spare kettle power plug, the difference in wire gauge compared tho the garden lights was glaring. I checked in with an elec engineer who thought the 12V cable thickness was a legacy of pre-LED lights and also other factors that shouldn't be a concern for the Sonoff part of the circuit. He suggested measuring the current draw. I did and it turned out to be around 400mA, so onward.

This is an outoor installation, so a waterproof box is prudent.

![Scripts folder](/assets/img//blog/20210814-garden-lights-sonoff/waterproof.jpg)

I used a USB 240V --> 5V power plug that conveniently was powered from a cable and fit nicely in the cable box.

Only one lead of the AC power is router through the relay, stowing away an extra run of cable in that waterproof cable box would take up extra space.

The rest of the setup in Tasmota OpenHab was straight forward and similar to the light setup for the [Sonoff FAN03 project](/2021-08-15-Installing-Fan03.html) 

---