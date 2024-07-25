---
title: 在GitHub上确保您的提交真实可信：一步一步配置GPG密钥
date: 2023-12-17T22:17:00+08:00
categories: [ 公众号文章 ]
tags: [ 不靠谱颜论 ]
---

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2023/1217/01.png" alt="题图" style="max-width:640px">
  <div><small>（题图由AI生成）</small></div>
</div>

引言
在GitHub上浏览代码时，您是否曾注意到，某些提交（commit）旁带有上图中类似的绿色“Verified”标签？这个标签的出现，意味着提交已通过GPG（GNU Privacy Guard）密钥进行签名和验证，证明该代码修改确实由指定的作者所完成。这不仅是确保代码安全性的关键，也是维护项目完整性的重要步骤。
在本文中，我将向您详细介绍如何配置GPG密钥，以在GitHub上获得这一标签。
公钥和私钥的基本概念
密钥通常成对出现，也就是我们经常听说的公钥和私钥。在深入了解如何使用GPG密钥之前，我们首先来看下公钥和私钥的基本概念：
公钥：这是一种可以安全地与他人共享的加密密钥。公钥分享给他人后，他人就可以用公钥来对加密数据进行验证。
私钥：与公钥相对应，私钥必须严格保密，仅在您自己的机器上保留，永远不会通过网络进行上传。一旦由于误操作或其他安全原因，导致私钥被传播，我们就认为该密钥对可能已经不安全。这时，就应该考虑重新生成新的密钥对，来对后续的数据进行加密和验证。
在使用GitHub的过程中，若我们在提交代码时指定了私钥，同时在GitHub上配置了该对应公钥，GitHub在展示提交时，就会进行检查，验证数据的密钥是否匹配，仅当确认该提交确实来自特定的开发者时，才会显示出上面提到的“Verified”标签。通过这个过程，就能确保代码提交的真实性和安全性，避免代码被劫持和恶意篡改。
配置GPG密钥的步骤
1. 生成GPG密钥：
在本地计算机上生成GPG密钥。不同操作系统有不同的工具：Windows上的Gpg4win，macOS的GPG Suite，以及Linux的GnuPG。
使用命令 gpg --full-generate-key 开始生成密钥的过程。
2. 获取GPG密钥ID：
完成密钥生成后，用 gpg --list-secret-keys --keyid-format LONG 获取您的GPG密钥ID。
3. 导出GPG密钥：
用 gpg --armor --export YOUR_GPG_KEY_ID 导出您的公钥。
将GPG密钥添加到GitHub账户
1. 添加公钥到GitHub：
在GitHub账户的“Settings” > “SSH and GPG keys” > “New GPG key”中，粘贴您的公钥。
2. 验证配置：
确保Git配置中使用的是正确的邮箱地址。
进行commit操作，并用 git log --show-signature 检查签名。
导出和导入GPG密钥
为了在不同的电脑上使用GPG密钥，您可以：
1. 导出GPG密钥：
使用 gpg --export --armor YOUR_GPG_KEY_ID > public-key.gpg 和 gpg --export-secret-keys --armor YOUR_GPG_KEY_ID > private-key.gpg 命令导出公钥和私钥。
2. 导入GPG密钥：
在新环境中使用 gpg --import public-key.gpg 和 gpg --import private-key.gpg 命令导入密钥。
总结
正确配置GPG密钥是网络安全的一个重要方面。此外，保护您的密钥和密码不被泄露，以及提高对网络诈骗的警觉性，也是至关重要的。
通过本文上述步骤，您可以确保GitHub提交的真实性和安全性。随着网络安全日益重要，掌握这些技能对每个开发者都至关重要。希望这篇文章能帮助您理解并配置GPG密钥，保护您的数字身份和代码安全。

<div class="p-5 text-center">--- END ---</div>

<i><b>注：</b>本文首发表于[“不靠谱颜论”公众号](https://mp.weixin.qq.com/s/mPxu4d7z65trQ49jWtyzig)，并同步至本站。</i>
