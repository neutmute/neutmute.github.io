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
This is some code I found as a comment on a YouTube video that I'm having trouble finding again. 

It worked up to about `base_power = 60` but any faster than that and it failed - the robot outrunning the speed of the control loop's ability to react.

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
base_power = 40

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
```

---