---
date: '2025-06-07T16:37:29+02:00'
draft: true
title: 'Menu_engine'
weight: 30
series: ["Documentation"]
series_order: 3
---

One of the most important utilities in the repository is the universal menu engine to avoid using interactive menus that require a mouse pointer, the utility is inspired by the various dmenu replacements and it can use one of them as a backend to display item lists, the concept is simple:

{{< mermaid >}}
flowchart LR
A[display list of elements]
B[chose element]
C[do something with the chosen element]
A --> B --> C
{{</ mermaid >}}


{{< alert >}}
For example a menu could display sites and open them in the browser and another one could display password elements from the password store and copy one of them in the clipboard :)
{{</ alert >}}

The advantage in a similar approach is that there is an omogeneous way of access to the most common operations that a user does with a desktop environment because most workflow can be reduced to the schema in the graph

