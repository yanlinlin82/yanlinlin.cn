---
title: 解决python-exec的报错信息
date: 2021-01-22 04:21:40+08:00
tags: [python, eselect, gentoo]
slug: solve-python-exec-error-message
---

## 问题

最近我的Gentoo Linux系统升级后，经常会出现如下报错：

```
python-exec: Invalid impl in /etc/python-exec/python-exec.conf: python3.6
```

究其原因，是因为python升级了新版本（`3.8`或`3.9`），而删除了旧版（`3.6`），但因为配置的版本选择器并没有相应更新，所以有此信息提示。

## 解决方法

解决方法如下（即使用`eselect python clean`）：

```sh
# eselect python list
Available Python interpreters, in order of preference:
  [1]   python3.9
  [2]   python3.7 (uninstalled)
  [3]   python3.6 (uninstalled)
  [4]   python3.8 (fallback)
```

```sh
# eselect python cleanup
```

```sh
# eselect python update
Switching to python3.9
```

```sh
# eselect python list
Available Python interpreters, in order of preference:
  [1]   python3.9
  [2]   python3.8 (fallback)
```

## 其他

若本地没有安装`eselect-python`，则可能在上述修复过程中，会出现如下提示：

```
# eselect python
!!! Error: Can't load module python
exiting
```

可以通过如下命令，安装相应软件包，进行解决：

```sh
emerge -av eselect-python
```

## 参考

* <https://archives.gentoo.org/gentoo-user/message/c11ef1c6a8e58940777b35039ef8ddfe>
