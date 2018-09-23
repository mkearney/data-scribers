---
title: "Random sampling"
author: 'jesse.tw'
date: '2017-12-24'
slug: random-sampling
categories:
  - bloglink
tags:
  - jessetw
---

The problem: you want to generate a random collection of letters. letters %>% sample(size = 4) %>% paste0(collapse = "") ## [1] "dlcz" Great. Now do it 10 times. letters %>% sample(size = 4) %>% paste0(collapse = "") %>% rep(8) ## [1] "rwuj" "rwuj" "rwuj" "rwuj" "rwuj" "rwuj" "rwuj" "rwuj" 😖. Why am I like this. Ok, rep copies the object 8 times. It doesn’t draw 8 samples. So just write a[... <i class="fas fa-external-link-alt"></i>](https://jesse.tw/post/sampling-replicate-v-rep/)

