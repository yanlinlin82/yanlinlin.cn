---
title: "记一次GDM登录失败问题的解决"
date: 2020-02-28T22:56:34+08:00
slug: gdm-login-failure
tags: [ gnome, gdm, posix ]
---

## 问题

这两天切换工作电脑，于是又一次重新[从头安装Gentoo Linux系统](https://www.gentoo.org/get-started/)。最近几年我一直用Gentoo，大概主要是被它的一句“[Gentoo is all about choices](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/About#Welcome)”所吸引。而最近开始[自己写ebuild](https://github.com/yanlinlin82/yanll-gentoo-overlay)，深入定制一些最新发布的软件安装，更感觉这套系统的强大和魅力。

这次安装系统，看到“ARM64体系”的Profile已经变成了stable状态，于是直接更新到该版本。与此同时，gcc也直接更新到9.2.0，并用这个最新版来编译整个系统。为方便，我还把[自己写的overlay](https://github.com/yanlinlin82/yanll-gentoo-overlay)也加入进来，就旧电脑上列出所有软件包的列表，在新电脑上一次性进行编译安装。

然而，正是这个过程，遭遇了Gnome桌面无法登录的问题。具体现象是，登录界面输入密码后，界面闪退，再次出现登录界面，始终无法进入到桌面。

## 探索

经查日志：

```sh
systemctl status gdm
journalctl
```

发现了如下报错：

```
gdm-password][3803]: gkr-pam: unable to locate daemon control file
```

网上也有类似问题的，对这个报错的解决是尝试定义环境变量`XDG_RUNTIME_DIR`，然而这并不能解决不能登录的问题。

再往后仔细翻查日志，才发现了罪魁祸首：

```
/usr/libexec/gdm-x-session[3834]: /etc/profile.d/gentoo-utils.sh: line 17: `emerge-sync': not a valid identifier
```

竟然是我自己写的一个脚本（放到了`/etc/profile.d/`目录中，方便全局生效供运行）导致了错误。

## 解决

尝试把其中的函数名进行改名（将减号`-`改为下划线`_`），再次尝试登录，结果就成功解决了该问题。

对于这个问题的原因解释，终于在GitHub上，[lxc项目的一个issue](https://github.com/lxc/lxc/issues/521)中找到，是由于`/etc/gdm/Xsession`脚本使用了`/bin/sh`（而非`/bin/bash`）作为解释器，该解释器强制要求函数名应符合POSIX规范（不能使用减号，而应使用下划线代替）。

最后，附上调研过程中，找到的同款问题链接：

* <https://bbs.archlinux.org/viewtopic.php?pid=1884097>
* <https://bbs.archlinux.org/viewtopic.php?id=211284>
* <https://github.com/lxc/lxc/issues/521>
