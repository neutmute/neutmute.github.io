---
layout: post
title: 'Spike Proportional Line Following in Word Blocks - Explained'
categories:
- blog
tags: 
- lego
- fll
- 
excerpt: Spike Line Following
---

The default line following sample using colour sensing in Spike wobbles from side to side as it flips from hunting for white and black.

The project hints at using reflectivity so here my solution

Here is the full shot
![Scripts folder](/assets/img/blog/20210930/line-follow.png)

## define BeepEvery

This is a debug / illustrative stack that you stick inside a loop which will highlight how fast the Spike blocking is through a loop iterating.

It takes a `Times` argument and will emit a beep every N `Times` it is called

## define LineFollow

All the line following code is contained in this block. It exposes several arguments. To use it, you will need to know a little about how the proportional line follower works.

### Overview

We want to drive the bot so it is constantly riding the light sensor halfway between the white and black edge. Note we are not following a line, but following an **edge**.

In a very fast loop, we are going to measure our current `reflectivity`, determine how far away we are from the ideal reflectivity and then drive the motors like a tank to make the bot slew left or right.

If we do this many times per second, then we can constantly adjust the power to the motors to steer the bot back toward the black/white edge as it drifts away.

The bot has no concept of where it is going, only how far it's sensor is away from the edge of the line

### Algorithm Detail

Upon entry, we initialise some variables and set our movement motors.
We define the ideal reflectivity we want to aim for - half way between white and black and call this `SetPoint`.

The stack starts a loop which it will exit after the `E motor` has travelled a certain distance.

Now we start the loop, reading the reflectivity from the sensor and assign it to the `reflection` variable.
Next we find the `Error` which is the difference between where we want to be (`SetPoint`) and where we are (`Reflection`).


<table class="table table-striped">
<thead>
<tr>
<th rowspan="2">Argument</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>wheelBasePower</td>
<td>The base power the bot will drive the wheels with</td>
</tr>
<tr>
<td>errorDivider</td>
<td>The base power the bot will drive the wheels with</td>
</tr>
<tr>
<td>cameraLetter</td>
<td>
Use `letter 1 of CD` to pick the sensor on port C
Use `letter 2 of CD` to pick the sensor on port D
</td>
</tr>
<tr>
<td>until</td>
<td>How far you want the bot to travel before stopping</td>
</tr>
</tbody>
</table>


Download the LLSP here ![Scripts folder](/assets/img/blog/20210930/spike-line-following-20210930.llsp)

---