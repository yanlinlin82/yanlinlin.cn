---
title: 使用Let's Encrypt免费配置HTTPS
date: 2024-01-26 21:41:00+08:00
categories: [公众号]
tags: [技术, 信息安全, HTTPS, 证书, 网站运维]
slug: lets-encrypt-https-setup
---

<div class="p-3 text-center">
  <img class="img-fluid" src="/uploads/2024/0126/01.png" alt="题图" style="max-width:640px">
  <div><small>（题图由AI生成）</small></div>
</div>

在数字时代，网站的安全性至关重要。对于一个需要登录的网站应用，如果不采用HTTPS协议，其登录时的用户名和密码将以明文形式在网络上传输，这是极其危险的操作，很容易被窃听而导致密码泄漏、身份冒用而造成损失。使用HTTPS不仅可以保护网站与用户之间的数据传输免受窃听和篡改，还可以提高搜索引擎排名和用户信任度。

配置HTTPS，需要在全球可信的证书颁发机构（CA）进行证书申请，并把获得的证书部署到网站服务器上。很多网站平台服务商都提供此项服务，但费用都不便宜（每年从数百元到数千元不等）。其实，有一个名为“Let's Encrypt”的公益机构，它致力于促进整个互联网的加密，能为所有人提供免费、自动化、开放的证书发放服务。本文就来介绍如何使用它，从而节省一大笔开支。

## 前期准备

在开始之前，确保你有一个有效的域名，并且你的网站托管在一个可以安装 SSL/TLS 证书的服务器上。服务器上安装配置好需要公开的网站，配置防火墙，对外暴露 80 端口（HTTP）和 443 端口（HTTPS）。先测试下，确保此时 80 端口（即通过 http:// 的网址）可以正确访问到该网站。

## 安装Certbot

Certbot是Let's Encrypt的推荐客户端。它可以自动化证书的获取和安装过程。安装Certbot通常只需几个简单的步骤，具体取决于你的服务器类型和操作系统。
对于Ubuntu服务器，可以使用如下命令：

```sh
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot
```

如果上述存在问题，也可以尝试采用 Python 的 pip 命令进行安装：

```sh
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
```

对于其他操作系统，或更多详细说明，也可以参考 certbot 官方网站的说明（https://certbot.eff.org/）。
生成和安装证书

一旦Certbot安装完成，你就可以生成和安装证书了。对于大多数服务器，这可以通过运行一个简单的命令完成。
例如，在Apache服务器上，你可以使用：

```sh
sudo certbot --apache
```

在Nginx服务器上，使用：

```sh
sudo certbot --nginx
```

上述命令会自动根据网站服务器的配置，找到并列出对外展示的域名，根据提示选择需要生成证书的域名，剩下的，Certbot脚本将自动访问远程服务器，提交申请，申请成功后下载证书，并配置到服务器上。之后重启网站服务后，应该就可以使用 HTTPS（即通过 https:// 的网址）访问相应网站了。

## 自动续订证书

Let's Encrypt的证书有效期为90天。幸运的是，Certbot可以设置自动续订。在大多数情况下，你可以通过以下命令设置自动续订：

```sh
sudo certbot renew
```

该命令还可以配置到 crontab 中，让其每半个月自动执行一次。这样就再不用担心证书过期的问题了。

## 总结

通过使用Let's Encrypt，可以轻松地为网站配置HTTPS，从而保证网站的信息安全，提升用户信任。而且，这个过程是完全免费的。希望这篇文章能帮助你轻松地实现网站的安全加密。

此外，HTTPS 其实建立起了一个安全的信息通道，在该通道中传输的数据不会被监控和重置，因此它其实能用于某些需要魔法的场景（有兴趣的可以参考这篇深入学习研究：<https://www.linuxbabe.com/ubuntu/set-up-v2ray-proxy-server>）。

<div class="p-5 text-center">--- END ---</div>

<i><b>注：</b>本文首发表于[“不靠谱颜论”公众号](https://mp.weixin.qq.com/s/1gVgK0Z_a_zDT2BVrPwlRg)，并同步至本站。</i>
