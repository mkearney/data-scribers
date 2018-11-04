---
title: "pyenv環境でaws cli入れたらコマンドが見つからない"
author: 'www.if-blog.site'
date: '2018-10-20'
slug: pyenv環境でaws-cli入れたらコマンドが見つからない
link: http://www.if-blog.site/post/2018/10/aws-cli-at-pyenv/
categories:
- bloglink
tags:
  - python
  - ifblogsite
---

pyenv環境でaws cli入れたらコマンドが見つからないって言われたので調べたメモ バージョン：pyenv:1.0.10 公式通りにインストールする。 $ pip3 install awscli --upgrade --user すると、 $ aws -bash: aws: command not found コマンドが見つからない.... 調べると、$HOME/.localにインストールされるらしいので、パスを通す。 aws --version aws-cli/1.16.29 Python/2.7.13 Darwin/16.7.0 botocore/1.12[... <i class="fas fa-external-link-alt"></i>](http://www.if-blog.site/post/2018/10/aws-cli-at-pyenv/)

