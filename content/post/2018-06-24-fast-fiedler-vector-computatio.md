---
title: "Fast Fiedler Vector Computation"
author: 'blog.schochastics.net'
date: '2018-06-24'
slug: fast-fiedler-vector-computatio
categories:
  - bloglink
tags:
  - blogschochasticsnet
---

[While this is easy to implement, it comes with the huge drawback of computing many unnecessary eigenvectors. We just need one, but we calculate all 100 in the example. The bigger the graph, the bigger the overheat from computing all eigenvectors. It would thus be useful to have a function that computes only a small number of eigenvectors, which should speed up the calculations considerably. The function below is an implementation to calculate the Fiedler vector for connected<i class="fas fa-external-link-alt"></i>](http://blog.schochastics.net/post/fast-fiedler-vector-computation/)

