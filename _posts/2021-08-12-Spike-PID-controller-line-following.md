---
layout: post
title: 'Spike Line following using PID control'
categories:
- blog
tags: 
- lego
- fll
- 
excerpt: Spike line following with a PID Controller
---

A PID Line Follower Python script for Lego Spike.
This is some code I found as a comment on a YouTube video and made some small changes to. 

```
from spike import PrimeHub, ColorSensor, MotorPair

hub = PrimeHub()
motor_pair = MotorPair('C', 'D')
color_sensor = ColorSensor('B')

Kp = 0.3
Ki = 0.001
Kd = 1.0

I = 0
previous_error = 0
base_power = 30
loop_counter = 0

#hub.left_button.wait_until_pressed()

while True:
    light_sensor_value = color_sensor.get_reflected_light()

    error = light_sensor_value - 50
    P = error
    I = I + error
    D = error - previous_error
    previous_error = error
    
    correction = int((P * Kp) + (I * Ki) + (D * Kd))
    left_motor = base_power + correction
    right_motor = base_power - correction

    motor_pair.start_tank_at_power(left_motor, right_motor)

    loop_counter += 1

    if loop_counter % 500 == 0 :
        hub.speaker.beep(60)

    #print(loop_counter)
```

* The PID Controller performs better when the sensor supplies a wide range of values - it can adjust the size of it's response based on how 'wrong' the measurement is from where we want it to be. The **reflected light** reading from Spike's sensor can range from around 10% for black and 95% for white surfaces. The **colour sensor** on the othe hand will only report 'Black' or 'White'. This doesn't allow the adjustment to be gradual and is why the reflected light reading is better than the colour reading from the light sensor.
* The `base_power` is currently set to 30. How much power can you apply before the line following fails?
* To show how fast the `while` loop is iterating, I added a `loop_counter` and make a beep every 500 times through. How often do you hear it as it counts another 500 times through the loop?
* The `print()` statement (commented out) sends information back to the Console tab on the Spike app but makes the robot very choppy. This must be a relatively expensive operation which interferes with the feedback loop.
* While playing with some variables and action, the robot can start behaving erratically as the feedback loop drives the correction higher and higher. The current `Kp, Ki, Kd` variables may be able to be better tuned but that is an advanced topic.

---