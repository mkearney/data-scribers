---
title: "Simple trick to speed up ODE integration in R"
author: 'sjfox.github.io'
date: '2017-04-24'
slug: simple-trick-to-speed-up-ode-i
categories:
  - rstats
tags:
  - sjfoxgithubio
---

[Introduction I recently was doing model fitting on a ton of simulations, and needed to figure out a way to speed things up. My first instinct was to get out of the R environment and write CSnippets for the pomp package (more on this in a later blog), or to use RCpp , but I used the profvis package to help diagnose the speed issues, and found a really simple change that can save a ton of time depending on your model. The model Let’s start by making a simple SIR...<click to read more>](https://sjfox.github.io/post/2017-04-19-timesteps-lsoda-and-epidemiological-models/)

