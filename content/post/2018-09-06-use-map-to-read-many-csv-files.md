---
title: "Use map to read many csv files"
author: 'jenrichmond.rbind.io'
date: '2018-09-06'
slug: use-map-to-read-many-csv-files
categories:
  - bloglink
tags:
  - jenrichmondrbindio
---

Get list of .csv files called files. The code below looks for files that have .csv as part of the filename in the the working directory The code below takes that list of files, pipes it to a map function that runs read_csv on each file, then pipes that to a rbind function that reduces those many files into a one dataframe called[... <i class="fas fa-external-link-alt"></i>](http://jenrichmond.rbind.io/post/use-map-to-read-many-csv-files/)

