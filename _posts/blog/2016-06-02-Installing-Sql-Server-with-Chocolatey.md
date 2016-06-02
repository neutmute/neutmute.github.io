---
layout: post
title: 'Installing SQL Server with Chocolatey'
categories:
- blog
tags: 
- chocolatey
- mssql
- sql
excerpt: Automated SQL Server installations with Chocolatey
---

After recently discovering [BoxStarter](http://boxstarter.org/), I worked on a [script](https://github.com/neutmute/nm-boxstarter/blob/master/base-box.ps1) to handle base Windows installations for work, home and relatives.

One suite of packages needed for my development enviroment is Microsoft SQL Server. There weren't any SQL packages available on [Chocolatey.org](https://chocolatey.org/packages) - so I made my own.

The three SQL Server packages available are for [SQL Server 2008](https://github.com/neutmute/nm-chocolatey-packs/tree/master/sqlserver2008), [SQL Server 2012](https://github.com/neutmute/nm-chocolatey-packs/tree/master/sqlserver2012) and [SQL Server 2016](https://github.com/neutmute/nm-chocolatey-packs/tree/master/sqlserver2016). I skipped 2014 since we aren't using it at work and it takes a bit of effort to put the packages together.

Each package supports all the documented installation parameters - reading them from environment variables. This isn't the preferred chocolatey way of passing parameters to a package but it felt less cumbersome than the officially sanctioned method. All the parameters from each server versions respective the MSDN page were placed into an Excel spreadsheet ([see example](https://github.com/neutmute/nm-chocolatey-packs/blob/master/sqlserver2016/docs/sql2016_ParamGenerator.xlsx?raw=true)) and used to generate the PowerShell required to parse the parameters and place them in the configuration.ini file.

The packages work well - see their respective `readme.md` files on github for usage. Unfortunately they were rejected from Chocolatey.org because they require the user to supply the path to the installation media. Even though SQL 2014 and SQL 2016 are now free, Microsoft don't allow anonymous downloads of the ISO's.

The source for the packages are available in the [nm-chocolatey-packs](https://github.com/neutmute/nm-chocolatey-packs) repository and instructions for usage are in the same repo. 

See the [SQL Server 2008](https://github.com/neutmute/nm-chocolatey-packs/tree/master/sqlserver2008), [SQL Server 2012](https://github.com/neutmute/nm-chocolatey-packs/tree/master/sqlserver2012) and [SQL Server 2016](https://github.com/neutmute/nm-chocolatey-packs/tree/master/sqlserver2016) `readme.md` files for more information and examples.

---
