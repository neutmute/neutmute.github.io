---
layout: post
title: 'Compiling TBB, EmguCV, OpenCV for Raspberry Pi 3'
categories:
- blog
- mono
- opencv
- raspberry pi
tags: 
- emgucv
- opencv
- tbb
excerpt: Notes on compiling Intel Thread Building Blocks (TBB) and OpenCV on Raspberry Pi 3
---
I [previously documented ](/2015/06/20/Compiling-TBB-EmguCV-OpenCV-Raspbian/)how to build TBB for Raspberry Pi 2. 
This entry shows how to do it for the Raspberry Pi 3 which is an ARMv8 Cortex-A53 processor and needed some extra steps to get working.

#### 1) Compile TBB
Compile TBB source following [these instructions](http://raspberrypi.stackexchange.com/a/27262/10501) from Stack Exchange

#### 2) Fix TBB source files
These steps weren't necessary to get `TBB` compiled but were necessary to get EmguCV/OpenCV going.
Credit to [Mihai Ilie](http://stackoverflow.com/questions/30131032). 

1.Go to file `gcc_armv7.h` line 31 and comment lines  
 
    30 #if !(__ARM_ARCH_7A__)
    31 #error compilation requires an ARMv7-a architecture.   
    32 #endif

2.Next in the same file `gcc_armv7.h` go to line 56 and replace it with 
    
    56 #define __TBB_full_memory_fence() 0xffff0fa0  // __asm__ __volatile__("dmb ish": : :"memo    ry")

#### 3) Compile EmguCV / OpenCV
Firstly make sure you have sourced the tbb vars (`source ./tbbvars.sh`).

Instead of executing the cmake bash script as per the emgu wiki, do this from the emgucv repo root.

    cmake -DBUILD_TESTS:BOOL=FALSE -DBUILD_PERF_TESTS:BOOL=FALSE -DBUILD_opencv_apps:BOOL=FALSE -DBUILD_DOCS:BOOL=FALSE -DWITH_TBB:BOOL=TRUE -DWITH_OPENMP:BOOL=TRUE -DWITH_CUDA:BOOL=FALSE -DWITH_OPENCL:BOOL=FALSE -DWITH_IPP:BOOL=FALSE -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules -DBUILD_opencv_ts:BOOL=FALSE -DBUILD_WITH_DEBUG_INFO:BOOL=FALSE -DBUILD_SHARED_LIBS:BOOL=FALSE  -DTBB_INCLUDE_DIRS:PATH=~/tbb44_20160526oss/include -DTBB_LIB_DIR:PATH=~/tbb44_20160526oss/build/linux_armv7_gcc_cc4.9.2_libc2.19_kernel4.4.13_release
    
The differences in the above command from the emgucv bash script are these switches 

    -DWITH_TBB:BOOL=TRUE
    -DTBB_INCLUDE_DIRS:PATH=~/tbb44_20160526oss/include 
    -DTBB_LIB_DIR:PATH=~/tbb44_20160526oss/build/linux_armv7_gcc_cc4.9.2_libc2.19_kernel4.4.13_release

Of course the dir paths will change depending on the downloaded version of TBB.

#### 4) Test
Execute `~/emgucv/bin/mono Example.FaceDetection.mono.exe`