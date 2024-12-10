---
date: '{{ .Date }}'
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
slug: '{{ replaceRE "^\\d{6}-" "" .File.ContentBaseName }}'
categories:
  - 
tags:
  - 
draft: true
---
