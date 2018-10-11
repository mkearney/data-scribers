---
title: "Everything is spiraling out of control!"
author: 'lenkiefer.com'
date: '2018-08-16'
slug: everything-is-spiraling-out-of
link: http://lenkiefer.com/2018/08/16/everything-is-spiraling-out-of-control/
categories:
- bloglink
tags:
  - rstats
  - python
  - lenkiefercom
---

I saw this fun bit of R code in a tweet by user aschinchon. df <- data.frame(x=0, y=0) for (i in 2:500) { df[i,1] <- df[i-1,1]+((0.98)^i)*cos(i) df[i,2] <- df[i-1,2]+((0.98)^i)*sin(i) } ggplot2::ggplot(df, aes(x,y)) + geom_polygon()+ theme_void()#rstats pic.twitter.com/cgNjyk405f - Antonio S[... <i class="fas fa-external-link-alt"></i>](http://lenkiefer.com/2018/08/16/everything-is-spiraling-out-of-control/)

