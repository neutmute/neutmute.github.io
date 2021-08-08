---
layout: post
title: 'Spike Prime Training Camp - Drive on a Line'
categories:
- blog
tags: 
- lego
- fll
- 
excerpt: Line Tracking Hints
---

Some things about the Drive on a Line lesson weren't obvious to me, here are my notes

## Start moving at block explained

Spike Prime has a lesson module `Training Camp 3: Reacting to Lines` with a starter program in lesson 04/06 as follows

![Scripts folder](/assets/img/blog/20210808/drive-on-a-line.png)

The program can tracks a coloured line but understanding it stumped me initially.

The trick to know is the `start moving at` block controls both motors in one command.
The first variable being the left, the second variable being the right.
Note the two usages in the program flip the left and right power and this is how the oscillating hunt behaviour happens.

## Find more Blcoks

Lesson 05/06 hints to use the reflection block but by default it can't be found in the left hand side panel.
The lesson has simplified the available blocks. Expose the rest of the blocks using the Lesson toggle switch at the bottom of the panel

![Scripts folder](/assets/img/blog/20210808/drive-on-a-line.png)

## Reflection Sensor Block

The reflection sensor block doesn't allow the specification of a colour, it's testing for reflected light - the light emitted by a light sensor

![Scripts folder](/assets/img/blog/20210808/reflection-block.png)

What does a black surface with with light landing on it?

So using this block we no longer have a _black line follower_ but a ... ?

---