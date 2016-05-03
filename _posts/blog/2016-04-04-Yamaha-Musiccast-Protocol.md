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

    This post will be updated over time

I bought a WX-030 Yamaha MusicCast speaker and am impressed with its capabilities. It would be nice though to be able to stream the MusicCast app to my PC speakers 
in another room to the WX-030 so I have been using Wireshark to investigate the protocol to see if I could emulate it.


The physical Yamaha device
- Listens on multiple ports for HTTP requests
- Uses multicast UDP
- Uses DLNA

My ASP.NET Core project `Swimbait` to emulate the device resides on [GitHub](https://github.com/neutmute/swimbait).

### Device Discovery
The first thing an emulator must do is emulate the `connect` button on the physical device.
This is done via a UDP multicast containing JSON data with the devices address:

    {
       "location":"http://192.168.1.213:49154/MediaRenderer/desc.xml",
       "ack":"http://192.168.1.213:51000/MusicCastNetwork/InitialJoinComplete"
    }


### Discovery Handshake
Once that is done, the MusicCast application will initiate a series of HTTP queries to discover the device and give it a name. A listing of URI's that the emulator must respond to are as follows

	/MediaRenderer/desc.xml
    /MusicCastNetwork/InitialJoinComplete
    /YamahaExtendedControl/secure/v1/netusb/getAccountStatus
    /YamahaExtendedControl/secure/v1/system/getNetworkStatus
    /YamahaExtendedControl/v1/dist/getDistributionInfo
    /YamahaExtendedControl/v1/main/getSignalInfo
    /YamahaExtendedControl/v1/main/getStatus
    /YamahaExtendedControl/v1/main/prepareInputChange?input=airplay
    /YamahaExtendedControl/v1/main/setInput?input=airplay
    /YamahaExtendedControl/v1/netusb/getPlayInfo
    /YamahaExtendedControl/v1/netusb/getPresetInfo
    /YamahaExtendedControl/v1/system/getDeviceInfo
    /YamahaExtendedControl/v1/system/getFeatures
    /YamahaExtendedControl/v1/system/getFuncStatus
    /YamahaExtendedControl/v1/system/getLocationInfo
    /YamahaExtendedControl/v1/system/getNameText
    /YamahaExtendedControl/v1/system/getNameText?id=main
    /YamahaExtendedControl/v1/system/getNetworkStandby
    /YamahaExtendedControl/v1/system/getTag
    /YamahaExtendedControl/v1/system/getTag?id=main
    /YamahaExtendedControl/v1/system/isNewFirmwareAvailable?type=network
    /YamahaExtendedControl/v1/system/setLocationId
    /YamahaExtendedControl/v1/system/setLocationName
    /YamahaExtendedControl/v1/system/setNameText
    /YamahaExtendedControl/v1/system/setTag?id=main&tag=3
    /YamahaExtendedControl/v1/system/stopInitialJoin
  
### Secure Responses
Several calls in the above list are on a `secure` route. It is unknown whether the responses are ROT-13 or AES.
For the moment,


---
