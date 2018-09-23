---
title: "Streaming JSON with Jackson"
author: 'sohlich.github.io'
date: '2017-02-08'
slug: streaming-json-with-jackson
categories:
  - bloglink
tags:
  - sohlichgithubio
---

[Sometimes there is a situation, when it is more efficient to parse the JSON in stream way. Especially if you are dealing with huge input or slow connection. In that case the JSON need to be read as it comes from input part by part. The side effect of such approach is that you are able to read corrupted JSON arrays in some kind of comfortable way. To simplify the approach, the combination of ObjectMapper with sequetial reading of JSON data could be used.The code of the complete solution could be<i class="fas fa-external-link-alt"></i>](https://sohlich.github.io/post/jackson/)

