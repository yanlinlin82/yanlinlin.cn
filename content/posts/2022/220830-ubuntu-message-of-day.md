---
title: 登录Ubuntu时显示的启动文本信息
date: 2022-08-30T07:14:00+08:00
categories: [ IT技巧 ]
tags: ["Ubuntu"]
---

## 问题

每天第一次登录Ubuntu时，系统都会提示如下展示的诸多信息，包括当前系统状态信息，是否有可用升级软件包等：

```
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.10.16.3-microsoft-standard-WSL2 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Aug 29 10:52:17 CST 2022

  System load:  1.4638671875        Processes:             27
  Usage of /:   42.9% of 250.98GB   Users logged in:       0
  Memory usage: 8%                  IPv4 address for eth0: 172.26.69.235
  Swap usage:   0%

0 updates can be applied immediately.

This message is shown once a day. To disable it please create the
/home/yanll/.hushlogin file.
```

那么，这些信息从何而来呢？

## 解答

该信息称为“Message of the Day”，简写为`motd`。可通过如下命令重现：

```
$ run-parts /etc/update-motd.d/
```

这里，`run-parts`是一个自动执行某个目录下所有脚本的命令。也因此，我们可以通过往该目录中增加新的脚本，来轻易定制启动提示内容，以及嵌入期望被自动执行的其他任务。

如果只是想查看该结果，即查看上次运行的文字结果，而非重新运行一次这些命令，可以查看如下文件：

```
$ cat /var/run/motd
```

最后，如果想禁用此提示功能，可以使用命令：

```
touch ~/.hushlogin
```

## 参考链接

1. <https://askubuntu.com/questions/319528/how-to-see-the-details-which-ubuntu-shows-at-the-time-of-login-anytime>
2. <https://linuxconfig.org/how-to-change-welcome-message-motd-on-ubuntu-18-04-server>
