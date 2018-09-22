---
title: "Deploy on Clever Cloud with Bitbucket Pipelines"
author: 'sohlich.github.io'
date: '2017-08-31'
slug: deploy-on-clever-cloud-with-bi
categories:
  - bloglink
tags:
  - sohlichgithubio
---

[First, we need to add a Dockerfile to application folder (for the simplicity). The most simple Dockerfile could look like following one. The important step in Dockerfile is the exposing of port 8080. The Clever Cloud requires this port as a default HTTP port. If the application does not respond on this port, the monitor tool evaluates the application as non-working and the deployment fails. The binary itself will be built during the Pipelines run. We can test the Dockerfile by building the...<click to read more>](https://sohlich.github.io/post/clever_cloud_pipelines/)

