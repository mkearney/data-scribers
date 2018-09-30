---
title: "OSX as Syslog server"
author: 'www.ifconfig.it/hugo'
date: '2011-01-11'
slug: osx-as-syslog-server
link: https://www.ifconfig.it/hugo/post/2011-01-11-osx-as-syslog-server/
categories:
- bloglink
tags:
  - ifconfigithugo
---

How to keep track of logs of a Cisco router using OSX? Easy task! Enable syslog listener on OSX: instructions here add this line to /etc/syslog.conf local7.* /var/log/cisco.log enable logging on the router: logging facility local7 ! ip address of iMac logging 10.0.0.1 install the Syslog Widget and configure it to check file /var/log/cisco.log[... <i class="fas fa-external-link-alt"></i>](https://www.ifconfig.it/hugo/post/2011-01-11-osx-as-syslog-server/)

