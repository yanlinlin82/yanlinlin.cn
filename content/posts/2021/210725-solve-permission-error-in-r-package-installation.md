---
title: R包安装失败报权限错误的解决
date: 2021-07-25 13:38:51+08:00
description: "装 R 包时 mv 挪 00LOCK-xml2 报 Permission denied，在 install.packages 里加 INSTALL_opts = c('--no-lock') 绕开锁目录即可。"
slug: solve-permission-error-in-r-package-installation
---

安装R包时，遇到如下的权限错误问题：

```txt
R> install.package("xml2")
...
** checking absolute paths in shared objects and dynamic libraries
mv: cannot move '/home/yanll/R/x86_64-pc-linux-gnu-library/4.1/00LOCK-xml2/00new/xml2' to '/home/yanll/R
/x86_64-pc-linux-gnu-library/4.1/xml2': Permission denied
ERROR:   moving to final location failed
...
```

解决方法是：

```txt
R> install.packages("xml2", dependencies=TRUE, INSTALL_opts = c('--no-lock'))
```

参考：<https://askubuntu.com/questions/1163130/permission-denied-while-installing-r-package>
