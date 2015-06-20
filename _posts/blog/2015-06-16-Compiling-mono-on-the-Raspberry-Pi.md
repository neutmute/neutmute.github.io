---
layout: post
title: 'Compiling mono for Raspbian'
categories:
- blog
- mono
- raspberry pi
tags: []
monoVersionDownload: 4.0.2.4
monoVersionExtract: 4.0.2
excerpt: Notes on compiling mono for Raspbian
---
This is my cheat sheet for compiling mono on Raspbian which come from the [mono docs](http://www.mono-project.com/docs/compiling-mono/linux/).

First like yoghurt, you need mono to make mono
    
    sudo apt-get install git autoconf libtool automake build-essential mono-devel gettext 

Download and unzip the source, substituting {{page.monoVersionDownload}} or whatever the [latest version is](http://download.mono-project.com/sources/mono/):

    wget http://download.mono-project.com/sources/mono/mono-{{page.monoVersionDownload}}.tar.bz2
    tar xvf {{page.monoVersionDownload}}.tar.gz
    cd mono-{{page.monoVersionExtract}}

Finally, build it {{title}}

    ./configure --prefix=/opt/mono-{{page.monoVersionExtract}}
    make
    sudo make install

Except then there are two versions of mono:

1. apt-get version 
1. freshly compiled 

I haven't figured out how to swap them cleanly. This is how I hack it:

    sudo mv /usr/bin/mono /usr/bin/mono-3.2.8 ### kill the old mono. probably a better way? 
	### reverse above: sudo mv /usr/bin/mono-3.2.8 /usr/bin/mono
    export PATH=$PATH:/opt/mono-{{page.monoVersionExtract}}/bin ### add this to  ~/.profile
    sudo visudo ### edit secure path to include mono bin folder for sudo'd commands
     
