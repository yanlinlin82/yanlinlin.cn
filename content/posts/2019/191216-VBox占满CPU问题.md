---
title: "VirtualBox占满CPU的问题及解决"
date: 2019-12-16T23:10:27+08:00
tags: [ virtualbox, windows, cpu, htop ]
---

由于我日常使用的是Linux操作系统，但偶尔又需要使用Microsoft Office，于是就只好在VirtualBox中安装了Windows 10，在需要的时候打开来使用。

最近发现，一旦Windows虚拟机开上一段时间后，整个笔记本电脑就开始变得滚烫。有时候甚至系统完全卡死，没有任何响应，只能长按电源键，强制断电后重新启动。一直没有找到真正的原因。

今天终于逮到一个机会，电脑刚开始发热，但还不至于完全卡死，用`htop`命令检查了一下Linux主机的状态，发现如下图所示：

![](images/2019/1216/screenshot-1.png)

八个CPU核（其实是四核超线程的结果），其实只有一个被kernel thread完全占满（右上角红色显示的那条柱子）。而系统日志（`dmesg -T | less`）则显示了“`CPUn: Package temperature above threshold, cpu clock throttled (total events = xxxx)`”的错误：

![](/images/2019/1216/screenshot-2.png)

于是进入虚拟机界面，在Windows桌面上打开了任务管理器，终于找到了罪魁祸首“Microsoft Office SDX Helper”：

![](/images/2019/1216/screenshot-3.png)

在网上搜索了一下，发现这个程序果然坑害了许多人，大家都纷纷控诉CPU被它吃掉。

最终，杀掉该进程，并在任务计划程序（开始菜单，输入“task”可找到）中，将对应进程禁用掉（避免它再次悄悄启动），问题解决：

![](/images/2019/1216/screenshot-4.png)

不过该程序应该是Microsoft Office的自动更新检查程序，所以，相应地，后续升级，就得靠手动检查并更新了。

参考网址：<https://www.itexperience.net/2019/09/23/easy-fix-microsoft-office-sdx-helper-high-cpu-usage/>
