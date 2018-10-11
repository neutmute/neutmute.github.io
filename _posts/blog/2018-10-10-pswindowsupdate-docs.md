---
layout: post
title: 'PSWindowsUpdate docs'
categories:
- blog
tags: 
- PSWindowsUpdate
- powershell
excerpt: Using PSWindowsUpdate
---

Finding help on the [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) is pretty sketchy. These are some notes of collected on getting it to work

## Installation

```
Install-Module -Name PSWindowsUpdate -Force -AllowClobber
```

`-AllowClobber` is useful when BoxStarter has been used to bootstrap the box

## Usage

* `Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot -Verbose -NotTitle 'preview'`

* `Get-WuRebootStatus`

## Help

* `get-command -module PSwindowsUpdate`
* `Help Get-WindowsUpdate –full`

---
