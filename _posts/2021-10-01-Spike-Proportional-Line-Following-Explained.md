---
layout: post
title: 'How to understand Proportional Line Following in Spike Word Blocks'
categories:
- blog
tags: 
- lego
- fll
- 
excerpt: Spike Line Following
---


The default line following sample using the Spike colour sensor wobbles from side to side as it flips from hunting for white and black.

Implementing PID control in Word Blocks is cumbersome, so here is a proportional-only follower.

![Scripts folder](/assets/img/blog/20210930/line-follow.png)

[Download the LLSP here](/assets/img/blog/20210930/spike-line-following-20210930.llsp)

## `define BeepEvery`

This is a debug / illustrative stack that you stick inside a loop which will highlight how fast the Spike blocking is through a loop iterating.

It takes a `Times` argument and will emit a beep every N `Times` it is called

## `define LineFollow`

All the line following code is contained in this block. It exposes several arguments. To use it, you will need to know a little about how the proportional line follower works.

### Overview

We want to drive the bot so it is constantly riding the light sensor halfway between the white and black edge. Note we are _not_ following a line, but rather following an **edge**.

In a very fast loop, we are going to measure our current `reflectivity`, determine how far away we are from the ideal reflectivity and then drive the motors like a tank to make the bot slew left or right and steer back toward the edge.

If we do this many times per second and constantly adjust the power to the motors, we can steer the bot back toward the black/white edge as it drifts away.

The bot has no concept of where it is going, only how far it's sensor is away from the edge of the line

### Algorithm Detail

Upon entry, we initialise some variables and set our movement motors.
We define the ideal reflectivity we want to aim for - half way between white and black and call this `SetPoint`.

The stack starts a loop which it will exit after the `E motor` has travelled a certain distance.

Now we start the loop, reading the reflectivity from the sensor and assign it to the `reflection` variable.

We find the `Error` which is the difference between where we want to be (`SetPoint`) and where we are (`Reflection`).

Let's jump ahead to what we want to do. We want to drive the two motor's with even power when we are going straight, and like a tank, drive one faster than the other to turn. Make the left motor faster, we turn right. Make the right motor faster, we turn left.

In order to do this we will apply the motors with a `wheelBasePower` and add a `differentialPower` to the left but _subtract_ the `differentialPower` to the right. 

If `differentialPower` is positive, we will drive the left motor faster and turn right. 
If `differentialPower` is negative, we will drive the right motor faster and turn left.

Apply the calculated `TrackPowerLeft` and `TrackPowerRight` to the motors and repeat, all the while steering back toward the `SetPoint` value that we want.

#### Proportional

Now, where was the propotion? We skipped over that but let's address it now. Consider that if we are very close to our `setPoint` we don't want to overcorrect and so should apply a light touch on the steering. If however we are far away from our `setPoint` then we should steer more aggressively to get back on track. Note that this is a decision an action made in 10th's of a second that is then repeated again and again.

What we want is a proportional response and that is obtained when we set

`differentialPower  = Error / errorDrivider`

The `errorDivider` being the number that transforms the measured `error` into a suitable value to apply to the motors. Empirically, we found the best value is about `2.5`. Bringing the value lower so that it makes the steering more agressive doesn't necessairily help accuracy because it makes the bot slew so far off track it loses the edge, sending it into a pirouette over a desert of white.

---