---
title: 使用Linux命令进行拼图
date: 2021-01-12 19:34:52+08:00
tags: [linux, image-magik]
slug: using-linux-commands-for-image-tiling
---

使用`ImageMagick`中的`convert`工具：

水平拼图：

```
convert +append 1.png 2.png ... out.png
```

垂直拼图：

```
convert -append 1.png 2.png ... out.png
```

参考：[博客园：ImageMagick 拼图及切图方法](https://www.cnblogs.com/mfryf/p/3873151.html)
