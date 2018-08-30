---
layout: post
title: 'detnsw wifi Settings for Ubuntu'
categories:
- blog
tags: 
- detnsw
- wifi
- 
excerpt: Configuring Ubuntu Mate
---

This is how to connect an Ubuntu MATE Linux laptop to the wifi network of a NSW public school as of August 2018

![Scripts folder](/assets/img/blog/20180830/wifi-settings.png)

* SSID: detnsw
* Authentication: PEAP
* Anonymous identity: leave blank
* Domain: leave blank
* CA certificate: None
* No CA Certificate is required: checked
* PEAP Version: Automatic
* Inner Authentication: MSCHAPv2
* Identity: user.name@detnsw
* Password: your portal password


![Scripts folder](/assets/img/blog/20180830/proxy.png)
* Setting the Proxy PAC on the **Proxy** tab of the network connection didn't help.
* Setting the Autoconfiguration URL to `http://pac.det.nsw.edu.au/fib/proxy.pac` in the **Network Proxy** settings did the trick

---
