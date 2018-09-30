---
title: "How to change a L2L VPN peer IP on Cisco ASA 8.3(2)4"
author: 'www.ifconfig.it/hugo'
date: '2012-05-29'
slug: how-to-change-a-l2l-vpn-peer-i
link: https://www.ifconfig.it/hugo/post/2012-05-29-asavpnpeeripchange/
categories:
- bloglink
tags:
  - ifconfigithugo
---

Today a customer called to change the IP address of a L2L VPN peer on his Cisco ASA 8.3(2)4. The task can be divided in 3 steps: 1) Get the VPN password. It should be written somewhere in the network documentation, as stated by rule 7, but you know, password sometimes just get lost. 2) Find and update crypto map asa# sh run | b peer 1.1.1[... <i class="fas fa-external-link-alt"></i>](https://www.ifconfig.it/hugo/post/2012-05-29-asavpnpeeripchange/)

