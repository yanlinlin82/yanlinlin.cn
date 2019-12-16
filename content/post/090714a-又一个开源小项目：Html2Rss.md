---
title: 又一个开源小项目：Html2Rss
slug: another-open-source-project-html2rss
date: 2009-07-14T00:21:00+08:00
place: 北京
tags: [ 开源, RSS ]
host-at: Oray
---
由于懒惰，我不愿总是机械地打开一系列网址，所以，几年前，我就已经开始使用RSS。把内容订阅到RSS浏览器中，每天打开RSS浏览器来看看，也就知道哪些网站更新了什么。那时我还在用本地安装的RSS浏览器，直到两年前，换到Google Reader的在线RSS浏览器，更加发觉RSS的强大和方便。于是又不断从网上搜罗了不少RSS，使自己离所需的信息更“近”些。

然而，虽然现在RSS已经是一种很普遍的东西，但仍然还有些网站并不提供RSS，让我不得不经常手工打开这些网址来浏览。为此，我曾经用Perl写过一些小程序来检查，并在内容发生更新后发送邮件通知我自己，然而这种方式仍然不如RSS来得方便。虽然网上也有一些从HTML到RSS的转换程序，但感觉都不是太好用，所以，一直有想法自己做一个。

直到今天，这个想法才算基本实现：<http://yanlinlin82.vicp.net/blog/projects/html2rss/>。

在自己的网站上架设起来，并把北大生科院的几个网页转换了一下。比如[ABC的通知页面](http://abc.cbi.pku.edu.cn/notice.php)被我通过页面<http://yanlinlin82.vicp.net/apps/html2rss/html2rss.php?id=1>转换成了RSS。现在终于可以在Google Reader中看到其通知内容，不用担心由于几天忘记打开相关页面而错过了重要通知。感觉很不错！
