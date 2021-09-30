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

Download the LLSP here ![Scripts folder](/assets/img/blog/20210930/spike-line-following-20210930.llsp)

# How to Use it

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
<td>Set this to between 25 and 30. If you go to fast, you may lose track of the line</td>
</tr>
<tr>
<td>errorDivider</td>
<td>
Set this to about 2.5. Feel free to experiment, changing the values by 0.1 at a time.
The smaller the value, the more agressively the bot will turn to get back on track.
The bigger the value, it will make smaller more subtle turns.

Turn too agressively and it will turn itself right off the edge. Too slow and it may not navigate a tight turn!
</td>
</tr>
<tr>
<td>cameraLetter</td>
<td>
Set the digit to 1 for Port C.
Set the digit to 2 for Port D.
</td>
</tr>
<tr>
<td>until</td>
<td>How far you want the bot to travel before stopping</td>
</tr>
</tbody>
</table>

---