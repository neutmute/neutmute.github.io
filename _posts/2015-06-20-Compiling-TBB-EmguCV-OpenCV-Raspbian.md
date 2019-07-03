---
layout: post
title: 'Compiling TBB, EmguCV, OpenCV on Raspbian'
categories:
- blog
- mono
- opencv
- raspberry pi
tags: 
- emgucv
- opencv
- tbb
tbbVersion: tbb43_20150611oss
excerpt: Notes on compiling Intel Thread Building Blocks (TBB) on Raspbian
---
This is my cheat sheet for compiling Intel Thread Building Blocks (TBB) on Raspbian for the Pi v2 (ARMv7) and then compiling EmguCV with it:


	# Download and unpack
    wget https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/{{page.tbbVersion}}_src.tgz
    tar xvf {{page.tbbVersion}}_src.tgz
	cd {{page.tbbVersion}}
	
	# Make flags from https://software.intel.com/en-us/forums/topic/500680
	make tbb CXXFLAGS="-DTBB_USE_GCC_BUILTINS=1 -D__TBB_64BIT_ATOMICS=0" 

Now the bins will have been created somewhere like

`~/tbb43_20150611oss/build/linux_armv7_gcc_cc4.6_libc2.13_kernel3.18.11_release`

Change into that folder and execute this script which will set the environment variables so the comiler will find our tbb binaries:

	source tbbvars.sh
	
Now change to the **emgucv** root folder and copy the cmake line from `$\platforms\raspbian\cmake_configure` but set WITH_TBB=true:

	cmake -DBUILD_TESTS:BOOL=FALSE -DBUILD_PERF_TESTS:BOOL=FALSE -DBUILD_opencv_apps:BOOL=FALSE -DBUILD_DOCS:BOOL=FALSE -DWITH_TBB:BOOL=TRUE -DWITH_OPENMP:BOOL=TRUE -DWITH_CUDA:BOOL=FALSE -DWITH_OPENCL:BOOL=FALSE -DWITH_IPP:BOOL=FALSE -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules -DBUILD_opencv_ts:BOOL=FALSE .

and finally lets build EmguCV/OpenCV executing `make`

Now we have a set of OpenCV binaries targeting TBB and the four cores of the Raspberry Pi 2!

Also see the [August 2016 update](/2016/08/16/Compiling-TBB-EmguCV-OpenCV-Raspberry-Pi/) for Raspberry Pi 3