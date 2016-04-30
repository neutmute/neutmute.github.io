---
layout: post
title: 'Yamaha MusicCast Protocol'
categories:
- blog
tags: 
- musiccast
- yamaha
excerpt: Attempts to reverse engineer the Yamaha MusicCast protocol
---
I bought a WX-030 Yamaha MusicCast speaker and am impressed with its capabilities. It would be nice though to be able to stream the MusicCast app to my PC speakers 
in another room to the WX-030 so I have been using Wireshark to investigate the protocol to see if I could emulate it.

So far I have found the speaker


- listens on multiple ports for HTTP requests
- Uses multicast UDP
- Uses DLNA

I've started an ASP.NET Core console application as my emulator which can be found on [GitHub](https://github.com/neutmute/swimbait)  

This blog entry will be a work in progress with my findings

---
