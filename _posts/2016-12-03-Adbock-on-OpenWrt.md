---
layout: post
title: 'adblock on OpenWRT'
categories:
- blog
tags: 
- openwrt
- adblock
excerpt: Running adblock services on a TL-WR1043N/ND with OpenWRT
---

Here are the steps I followed to get [adblock](https://github.com/openwrt/packages/tree/master/net/adblock/files) installed on Chaos Calmer [OpenWRT](https://openwrt.org/) running on a TL-WR1043N/ND.

1. Downloaded and installed `adblock` and `luci-app-adblock` as per the [readme](https://github.com/openwrt/packages/blob/master/net/adblock/files/README.md)
1. The Adblock page in Luci reported `runtime error, please check the log!`
2. Couldn't find any logs via SCP so SSH in and execute `/etc/init.d/adblock start` for a more helpful error
2. With that hint, edited `uhttpd config` as per the [readme](https://github.com/openwrt/packages/blob/master/net/adblock/files/README.md)
3. Try starting again and get `warn : please install 'uclient-fetch' or 'wget' with ssl support to use adblock`
4. Install wget: `opkg update & opkg install wget`
5. Try a restart: `/etc/init.d/adblock start`
6. Success!

    `domain adblock processing finished successfully (1.5.3, r46767, 03.12.2016 10:00:46)`
	
7. *Update DNS entries, surf the web, run some spammy apps on the iPad*
8. Query the stats: `/etc/init.d/adblock stats`

`firewall statistics:  9.85%/0% of all packets in prerouting chain are ad related & blocked`

Done!

---
