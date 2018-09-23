---
title: "Functional programming #rstats"
author: 'jesse.tw'
date: '2017-12-17'
slug: functional-programming-rstats
categories:
  - bloglink
tags:
  - rstats
  - jessetw
---

[. Your situation: you have a big data frame you want to apply a (pretty complex) function to each row you are on a Windows server For example, you know baby names are much cooler when they have no vowels and no uppercase letters. # a dataset of babynames library(babynames) # a function that drops vowels from names drop_vowels <- function(text) { gsub("[aeiou]", "", text) } mutate_names <- function(tbl) { # names are cooler with no vowels and no capital<i class="fas fa-external-link-alt"></i>](https://jesse.tw/post/rstats-closure-windows-parallel/)

