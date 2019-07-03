---
layout: post
title: 'Compiling EmguCV on Windows'
categories:
- blog
- emgucv
tags: []
excerpt: Notes on compiling EmguCV on Windows
---
Every time I decide to refresh my EmguCV Windows build from git I have to remember the little tricks in doing so as some of the official docs are out of date and slightly misleading.

These steps are accurate as of commit [56f898c] and works on my machine

1. Execute `\emgu-source\platforms\windows\Build_Binary_x86-64_intel_icl_doc.bat`
2. At the very bottom of the output of the batch file is a REM to do something like `devenv.exe /Build Release emgucv.sln  /out "build.log"`
3. Copy and paste that into the command line and execute it from the root of the repo. This will build the unmanaged code.
4. Tail the log file it creates to keep an eye on it
5. When finished, `\bin` will have some dll's populated
6. The EmguCV managed code can now be built and run from `Solution\VS2010_2012_2013`