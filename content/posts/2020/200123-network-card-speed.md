---
title: 如何在Linux下查看网卡带宽
date: 2020-01-23T17:52:33+08:00
tags: [ linux, network ]
---

在Linux命令行下，想要查看网卡的带宽上限，可以使用如下命令：

```sh
$ ethtool eth0 | grep Speed
```

若该命令不存在，在Gentoo系统中，可以这样进行安装：

```sh
$ sudo emerge -av ethtool
```

参考：[Server Fault: How do I verify the speed of my NIC?](https://serverfault.com/questions/207474/how-do-i-verify-the-speed-of-my-nic)
