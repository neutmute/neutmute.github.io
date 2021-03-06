---
layout: post
title: 'Roboking rotates and then turns off'
categories:
- blog
tags: 
- roboking
excerpt: What I did to fix our misbehaving Roboking
---
Our Korean imported Roboking `VR6272LVM` started acting up and refusing to clean.
The symptoms were

- Turn the robot on
- It starts rotating on the spot
- After a few rotations it announces cleaning is complete and tries to find the home station
- If the home station is turned on it just rotates forever
- If the home station is off it declares it can't find the homestation and turns off

Some Internet posts suggested cleaning the sensors but they weren't dirty. I decided to risk downloading firmware from the [English LG website](http://www.lg.com/au/support-product/lg-VR6270LVMB) for the Korean model. It announced the update was complete with `13865 software is loaded`.

After turning the robot off to remove the USB and turning it back on, it was back to its normal behaviour. So far so good!
I can't think of what the explanation might be** but at least I can spend time writing blog posts instead of sweeping floors.

---

** One thing I did recently was invert the robot to replace a broken sweeper. I wouldn't have thought that would cause a problem though

---

**Update** A year later in December 2016 and the hom-bot is going around in circles again. The LG Australia site doesn't have the firmware anymore but [Singapore has 16552](http://www.lg.com/sg/support/support-product/lg-VR6270LVMB) for `VR6270LVMB` which loaded fine. Again the behaviour has been fixed by a firmware update. I'll save the firmware this time in case it becomes unavailable. Perhaps writing the non volatile firmware resets accumulated training data which has caused the robot to misbehave. That is my current best theory on why this technique fixes the errant behaviour. 