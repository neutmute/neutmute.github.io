---
layout: post
title: 'Integrate AirGradient with OpenHAB'
categories:
  blog
excerpt: Adding an AirGradient Basic Pro kit to my OpenHAB home automation
---

   
How I integrated my AirGradient pro kit with OpenHAB

# AirGradient

There are a lot of forks of AirGradient's sample code but none were exactly what I needed to integrate into my OpenHAB setup so I started a clean fork and cherry picked/adjusted to keep it as close to AirGradient's reference implementation as possible

https://github.com/airgradienthq/arduino/compare/master...neutmute:arduino:master

With these changes, I can now browse to my AirGradient device IP and receive the data in JSON

```
{"wifi":-83, "rco2":486, "pm01":1, "pm10":1, "pm02":2, "pm02_aqi":8, "tvoc_index":100, "nox_index":1, "atmp":20.30, "rhum":76}
```

# OpenHAB

## Things

To expose the JSON data, it's a simple HTTP binding

```
Thing http:url:airgradient "AirGradient" [
    baseURL="http://192.168.20.138/",
    contentType="application/json",
    refresh=30] {
        Channels:
        Type number : wifi "WiFi Signal Strength" [ stateTransformation="JSONPATH:$.wifi" ]
        Type number : co2 "RCO2" [ stateTransformation="JSONPATH:$.rco2" ]
        Type number : pm01 "PM 0.1" [ stateTransformation="JSONPATH:$.pm01" ]
        Type number : pm10 "PM 10" [ stateTransformation="JSONPATH:$.pm10" ]
        Type number : pm02 "PM 0.2" [ stateTransformation="JSONPATH:$.pm02" ]
        Type number : pm02Aqi "PM 0.2 AQI" [ stateTransformation="JSONPATH:$.pm02_aqi" ]
        //Type number : tvoc_index "TVOC Index" [ stateTransformation="JSONPATH:$.tvoc_index" ]
        Type number : nox "NOX" [ stateTransformation="JSONPATH:$.nox_index" ]
        Type number : temperature "Temperature" [ stateTransformation="JSONPATH:$.atmp" ]
        Type number : humidity "Humidity" [ stateTransformation="JSONPATH:$.rhum" ]
}
```

## Items

Define the items with a bit of help from ChatGPT

```
Number AirGradientWiFiSignal "WiFi Signal Strength [%.0f dBm]" { channel="http:url:airgradient:wifi" }
Number AirGradientCO2 "CO₂ [%.0f ppm]" { channel="http:url:airgradient:co2" }
Number AirGradientPM01 "PM 0.1 [%.0f µg/m³]" { channel="http:url:airgradient:pm01" }
Number AirGradientPM10 "PM 10 [%.0f µg/m³]" { channel="http:url:airgradient:pm10" }
Number AirGradientPM02 "PM 2.5 [%.0f µg/m³]" { channel="http:url:airgradient:pm02" }
Number AirGradientPM02AQI "PM 2.5 AQI [%.0f]" { channel="http:url:airgradient:pm02Aqi" }
//Number AirGradientTVOCIndex "TVOC Index [%.0f]" { channel="http:url:airgradient:tvoc_index" }
Number AirGradientNox "Nitrous Oxides [%.0f]" { channel="http:url:airgradient:nox" }
Number AirGradientTemperature  "Temperature [%.1f °C]" <Temperature> { channel="http:url:airgradient:temperature" }
Number AirGradientHumidity "Humidity [%.0f %%]" <Humidity> { channel="http:url:airgradient:humidity" }
```

## Sitemap

```
sitemap airgradient label="Air Gradient"
{
    Frame label="Air Quality" {
        Text item=AirGradientWiFiSignal
        Text item=AirGradientCO2
        Text item=AirGradientPM01
        Text item=AirGradientPM10
        Text item=AirGradientPM02
        Text item=AirGradientPM02AQI
        //Text item=AirGradientTVOCIndex
        Text item=AirGradientNox
    }

    Frame label="Temperature & Humidity" {
        Text item=AirGradientTemperature
        Text item=AirGradientHumidity
    }
}
```

## InfluxDB Persist

With persistence to Influx, the only step remaining is some Grafana charting

```
    AirGradientWiFiSignal: strategy =everyChange, every10Minutes
    AirGradientCO2 : strategy =everyChange, every10Minutes
    AirGradientPM01: strategy =everyChange, every10Minutes
    AirGradientPM10: strategy =everyChange, every10Minutes
    AirGradientPM02: strategy =everyChange, every10Minutes
    AirGradientPM02AQI : strategy =everyChange, every10Minutes
    AirGradientNox : strategy =everyChange, every10Minutes
    AirGradientTemperature  : strategy =everyChange, every10Minutes
    AirGradientHumidity : strategy =everyChange, every10Minutes
```