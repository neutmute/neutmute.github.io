---
layout: post
title: 'How to Use Spike Proportional Line Following in Word Blocks'
categories:
- blog
tags: 
- lego
- fll
excerpt: Spike Line Following
---

The default line following sample using the Spike colour sensor wobbles from side to side as it flips from hunting for white and black.

Implementing PID control in Word Blocks is cumbersome, so here is a proportional-only follower.

![Scripts folder](/assets/img/blog/20210930/line-follow.png)

[Download the LLSP here](/assets/img/blog/20210930/spike-line-following-20210930.llsp)

## How to Use it

1. Take the `LineFollow` block and copy/paste it into your project.
2. From `My Blocks` in the left hand toolbar, drop in a call to it - as shown in the top right.
3. Populate the arguments as follows:

![Scripts folder](/assets/img/blog/20210930/args.png)

### wheelBasePower
Set this to between 25 and 35 depending on your course. If you go too fast, you may lose track of the line. Too slow is boring but works better on tighter turns.

### errorDivider

Set this to about `±2.5`. 

Make it `+2.5` to track the **left** edge, `-2.5` to track the **right** edge.

Feel free to experiment, by changing the value by `0.1` at a time within a range of `1.5 to 3.5` say.
The smaller the value, the more agressively the bot will turn to get back on track.
The bigger the value, it will make smaller more subtle turns.

Turn too agressively and it will turn itself right off the edge. Too slow and it may not navigate a tight turn!

### cameraLetter

Set the letter value `1` for Port C.

Set the letter value `2` for Port D.

Leave the `of` string as `CD`.

This is a bit of a hack to select the correct port when you are using two light sensor's.

### until

How far you want the bot to travel before stopping. 
This is the relative position of the wheel at the start block and is a positive number.

## How does it work?

This has explained how _to use_ the block. The [next post](../../10/01/Spike-Proportional-Line-Following-Explained.html) explains how _it works_.