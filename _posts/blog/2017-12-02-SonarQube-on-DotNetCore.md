---
layout: post
title: 'Sonarqube on .NET Core'
categories:
- blog
tags: 
- sonarqube
- dotnetcore
excerpt: Executing SonarQube builds for .NET Core
---

This is a cheatsheet so I remember the tricks I had setting up SonarQube scans in TeamCity. I had everything working fine on my machine (TM) but when trying to reproduce the sonar scan in TeamCity I ran into some difficulty.

First you will need to get the MSBuild scanner installed - if you use chocolatey, this is as simple as

`choco install msbuild-sonarqube-runner`

Next install `Build Tools for Visual Studio 2017` so you have the latest `msbuild`. Go ahead and add the install location to the PATH environment variable so that when TeamCity executes MSBuild it will find it in the path (I didn't use the MSBuild TeamCity runner)

This is well documented so broadly speaking, you do three things
1. Execute a sonar start command: `SonarQube.Scanner.MSBuild.exe /start <plus other args`
1. Compile your solution using `msbuild`
1. Execute a sonar end command: `SonarQube.Scanner.MSBuild.exe /end <plus other args`

One other rain dance I performed was after installing the .net core 2.0.3 SDK on TeamCity, I made sure that the `global.json` reflected the same minor version. I had developed on my machine using `2.0.0`, but installed `2.0.3` for TeamCity. This may not have been strictly required &lt;shrug&gt;.


### Troubleshooting

Also known as _things I learned along the way..._

> error MSB4062: The "IsTestFileByName" task could not be loaded from the assembly C:\TeamCity\buildAgent\work\2c063ed63bf5a595\.sonarqube\bin\SonarQube.Integration.Tasks.dll. Could not load file or assembly 'Microsoft.Build.Utilities.v4.0, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. The system cannot find the file specified. Confirm that the <UsingTask> declaration is correct, that the assembly and all its dependencies are available, and that the task contains a public class that implements Microsoft.Build.Framework.ITask. 

This error was because I was using `dotnet build` to compile the solution. I needed to install `Build Tools for Visual Studio 2017` and compile my solution using MSBuild instead.

> error MSB4236: The SDK 'Microsoft.NET.Sdk' specified could not be found.

This was because when I installed the `Build Tools for Visual Studio 2017` I neglected to add the .NET Core workload. I was building .NET Core 2.0 and the description talks about .NET Core 1.0. You need that workload as it contains other required goodies.

Note that some googling suggested that I should add environment variable `MSBuildSDKsPath` with a path to the SDK. This was a rabbit hole that produced other errors and in the end I had to **remove** this environment variable in order to get things working again.

> error CS0012: The type 'Object' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'.

I had this problem along the way, I forget what solved that issue.




---
