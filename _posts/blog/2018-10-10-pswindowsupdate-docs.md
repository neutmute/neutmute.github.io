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

* `Install-Module -Name PSWindowsUpdate -Force`

If BoxStarter is installed, you will need the `-AllowClobber` switch

* `Import-Module PSWindowsUpdate`

## Help

* `get-command -module PSwindowsUpdate`
* `Help Get-WindowsUpdate –full`

## Usage

* `Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot -Verbose -NotTitle 'preview'`

* `Get-WuRebootStatus`

---
