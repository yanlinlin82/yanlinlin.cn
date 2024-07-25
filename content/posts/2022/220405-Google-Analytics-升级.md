---
title: Google Analytics升级至v4
date: 2022-04-05T19:26:37+08:00
tags: [ 网站, "Google Analytics" ]
---

## 前言

不得不承认，想要持续做内容输出，不管哪种形式，最后我总逃不脱“三天打鱼，两百天晒网”的窘境。时间难以自由支配的原因很多，也通常很难改变。但作为解决方案，尽量降低内容分享的难度，也许是个办法。

于是，最近我花了些时间，尝试把各种零碎输出的内容进行汇总，统一放到个人网站上来。之所以选择个人网站这种“古老”的形式，是考虑到其灵活性（包括可以通过后台开发来定制不同的功能），希望能兼顾不同形式和内容。

配合这次更新，把一些原本存在显示问题的CSS样式也做了纠正。而最近几个月，Google Analytics也给我推送了多次邮件，建议升级到其v4最新版本。本篇，对这个升级过程，做下简单笔记。

## 关于 Google Analytics 升级

Google Analytics 是一个强大的网站分析工具。能够提供相比 Apache log 更精细的访问记录，用以了解网站访问用户的行为，并分析相关诉求，以完善网站功能，提供更好的服务。

通常，它提供一段脚本，将其插入到网页中，一旦用户访问该页面，这些脚本就会自动提取HTTP协议中的相关信息，存入数据库中，用于后续分析。

本次升级，其脚本从`analytics.js`更新为`gtag.js`，账号也从`UA-`开头变成了`G-`开头。提供了更精细和灵活的配置功能，比如可以不用修改网页，而直接在Google Analytics网站上进行配置，开关相关标签的跟踪。

## Google Analytics 账号更新

1. 用 Google 账号，登录 Google Analytics 网站： <https://analytics.google.com/analytics/>。
2. 在控制台中，选择 ADMIN 选项页，选择`UA-`账号。
3. 点击“GA4 Setup Assistant”菜单，在出现的面板中，选择“Get started”，根据提示完成账号升级。
4. 完成升级后，面板上方“Google Analytics 4 Property Setup Assistant”的右侧，出现绿色的“Connected”。
5. 点击“See your GA4 property”按钮，在“Property”菜单中选择“Dat Streams”。
6. 通过右侧“Add Stream”，可以添加网站域名，从而分配得到 Stream ID，以及相关的代码（在代码中也可以查到“`G-`”开头的编号），用于插入到网站页面中。

## Hugo 网站更新方法

1. Hugo（<https://gohugo.io/>）新版已经整合了相应的代码。目前 Ubuntu 中（通过`apt install`直接安装）的版本并不支持，可以通过手工下载最新版本（<https://github.com/gohugoio/hugo/releases>，下载amd64或系统相应的二进制发布包，解压缩后直接使用）。

2. 在页面中使用如下代码模板：

    ```html
    {{ template "_internal/google_analytics.html" . }}
    ```

3. 在网站配置文件`config.toml`中加入（*根据实际账号进行配置*）：

    ```txt
    googleAnalytics: G-MEASUREMENT_ID
    ```

## 自定义网站更新方法

1. 打开 Google Analytics 的控制台页面，找到 Property 中的 Data Stream。

2. 选中所配置的需要跟踪的网站 Data Stream，点击进入 Detail 页面。

3. 在页面中找到“Tagging Instructions”，选择“Global site tag (gtag.js)”，点击将自动展开。

4. 在展开的内容中，有类似如下的代码：

    ```html
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-XXXXXXXXXX');
    </script>
    ```

    将其拷贝并插入到自己网站页面中即可。

## 参考链接

* <https://marketingplatform.google.com/about/resources/use-googles-latest-dynamic-tagging-solution-for-better-site-measurement/>
* <https://gohugo.io/templates/internal/#google-analytics>
* <https://support.google.com/analytics/answer/10840722>
* <https://support.google.com/analytics/answer/9744165>
