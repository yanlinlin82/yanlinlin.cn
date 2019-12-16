---
title: 升级云服务器Ubuntu LTS版本时遇到的问题及解决
date: 2019-12-12T22:59:51+08:00
slug: ubuntu-lts-upgrade
tags: [ Ubuntu, upgrade ]
---

我的个人网站现在跑在云服务器上，由于安装时间稍早，使用的还是上一个LTS版本，最近登录提示：

```
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-170-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Overheard at KubeCon: "microk8s.status just blew my mind".

     https://microk8s.io/docs/commands#microk8s.status
New release '18.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.
```

于是尝试用`sudo do-release-upgrade`升级一下，结果遭遇如下错误提示而失败：

```
...

Checking package manager
Reading package lists... Done
Building dependency tree
Reading state information... Done

Invalid package information

After updating your package information, the essential package
'ubuntu-minimal' could not be located. This may be because you have
no official mirrors listed in your software sources, or because of
excessive load on the mirror you are using. See /etc/apt/sources.list
for the current list of configured software sources.
In the case of an overloaded mirror, you may want to try the upgrade
again later.
```

经排查，怀疑是`/etc/apt/sources.list`中配置的某些第三方镜像，无法被`do-release-upgrade`正确处理。于是考虑如下方法（重置该配置文件，并重新尝试升级）：

```sh
mv /etc/apt/sources.list ~/  # 备份
echo "deb http://archive.ubuntu.com/ubuntu bionic universe main" > /etc/apt/sources.list  # 只保留一个主源
do-release-upgrade
```

更新成功，问题解决。

---

问题排查过程中，参考了如下网页：

* <https://www.digitalocean.com/community/questions/cannot-update-to-19-04-the-essential-package-ubuntu-minimal-could-not-be-located-2>
* <https://serverfault.com/questions/836889/ubuntu-14-04-on-linode-not-doing-do-release-upgrade>
* <https://askubuntu.com/questions/124017/how-do-i-restore-the-default-repositories>
