---
layout: post
title: 'Cricket Chirping Circuit'
categories:
- blog
tags: 
- electronics
excerpt: Attempts to make a cricket chirping circuit
---
To help expose my son to some discrete electronics, I thought it would be a fun project to make a cricket chirping circuit. Now you can buy these as kits for $20 and they come complete with a PCB, parts and a guarantee it will work. Where is the fun in that though?

After some googling, I came across the [Urban Cricket](http://wiki.happylab.at/w/Urban_Cricket) project on Happy Labs. They have a [video of the cricket circuit working](https://www.youtube.com/watch?v=DyLsBAO6dLQ) and the design was simple enough so I set to work gathering the required parts from the local electronics store.

   ![Scripts folder](/assets/img/blog/20150904/Urban-cricket-schematic.gif)  

The above schematic is a nice hand drawn logical layout but not useful for copying onto a breadboard, so I reproduced it into a Fritzing schematic

![Scripts folder](/assets/img/blog/20150904/CricketChirper3_schem.png)

From the Fritzing schematic, I produced a breadboard diagram of the same

![Scripts folder](/assets/img/blog/20150904/CricketChirper3_bb.png)

It didn't take long to build and also it didn't take long to find something was wrong - there was no chirping. So in order debug the circuit I had to understand what it was trying to do

#### Schmitt Oscillators
Schmitt oscillators produce square waves according to the formula

![Scripts folder](/assets/img/blog/20150904/oscillator.png)

Read more on [talking electronics](http://www.talkingelectronics.com/pay/BEC-2/Page49.html) but using this information, we can determine what the three oscilators are doing

#### Oscillator 1
Is a 100kΩ / 100nF resistor, capacitor pair giving a frequency of [120Hz](http://www.wolframalpha.com/input/?i=1.2%2F%28100nF*100kOhm%29%29)

#### Oscillator 2
Is 39kΩ / 10μF giving a frequency of [3Hz](http://www.wolframalpha.com/input/?i=1.2%2F%2810uF*39kOhm%29%29)

#### Oscillator 3
Is 290kΩ / 100nF giving a frequency of [0.41Hz](http://www.wolframalpha.com/input/?i=1.2%2F%2810uF*290kOhm%29%29) - ie a 2.4 second period.


#### Piezo beeper
Finally I read this in the Happy Labs notes and it became clear

> The piezo beeper has a built in driver which means that a voltage applied will cause the beeper to generate noise not only a short click.

I wasn't using a piezo buzzer but a 0.25W speaker that I hacked out of a broken toy truck. The speaker needs to be oscillated at 3kHz to get a tone but the piezo just needs a DC voltage and has a built in driver to give the initial 3kHz. The first oscilator changes the 3kHz tone into a continuous chirp, the second oscilator turns chirp off and on a few times a second, the third makes it chirp for a few seconds at a time before resting. The urban cricket notes all stated this - it just took several readings for it to all sink in.

With the understanding that my speaker needed a 3kHz driver I tried a combination of resistor / capacitor to achieve this and it worked according to the bitscope but I couldn't get anything out the speaker. After playing about with a transistor driver I gave up and purchased the $3.50 piezo buzzer and it finally worked. 

Here is the [Fritzing layout for the Urban Cricket](/assets/img/blog/20150904/CricketChirper.fzz)
