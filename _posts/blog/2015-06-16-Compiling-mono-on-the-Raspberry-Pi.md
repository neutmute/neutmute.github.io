---
layout: post
title: 'Compiling mono for Raspbian'
categories:
- blog
- mono
- raspberry pi
tags: []
excerpt: Notes on compiling mono for Raspbian
---
This is my cheat sheet for compiling mono on Raspbian which come from the [mono docs](http://www.mono-project.com/docs/compiling-mono/linux/).

First like yoghurt, you need mono to make mono
    
    sudo apt-get install git autoconf libtool automake build-essential mono-devel gettext 

Download and unzip the source, substituting 3.12.0 or whatever the [latest version is](http://download.mono-project.com/sources/mono/):

    wget http://download.mono-project.com/sources/mono/mono-3.12.0.tar.bz2
    tar xvf 3.12.0.tar.gz
    cd mono-3.12.0

Finally, build it

    ./configure --prefix=/opt/mono-3.12.0
    make
    sudo make install

Except then there are two versions of mono:

1. apt-get version 
1. freshly compiled 

I haven't figured out how to swap them cleanly. This is how I hack it:

    sudo mv /usr/bin/mono /usr/bin/mono-3.2.8 ### kill the old mono. probably a better way? ### reverse: sudo mv /usr/bin/mono-3.2.8 /usr/bin/mono
    export PATH=$PATH:/opt/mono-3.12.0/bin ### add this to  ~/.profile
    sudo visudo ### edit secure path to include mono bin folder for sudo'd commands
     
