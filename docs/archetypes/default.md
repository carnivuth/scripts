---
date: '{{ .Date }}'
draft: true
title: '{{ replace .File.ContentBaseName "-|_" " " | title }}'
---
