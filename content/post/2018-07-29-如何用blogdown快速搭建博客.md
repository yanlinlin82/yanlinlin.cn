---
title: 如何用blogdown快速搭建博客
date: '2018-07-29T17:59:50+08:00'
slug: how-to-establish-a-blog
tags: [ blogdown, 博客 ]
---

使用[blogdown](https://bookdown.org/yihui/blogdown/)搭建博客网站是一个很简单的过程。

一个简化版的快速上手过程如下：

    $ mkdir my-site  # 创建空目录，用于存放网站
    $ cd my-site
    $ R
    R> install.package("blogdown")  # 只需要在第一次使用时安装即可
    R> library(blogdown)
    R> new_site()            # 创建网站
    R> serve_site()          # 启动服务，并在浏览器中打开页面（此后修改会自动刷新）
    R> new_post("标题名称")  # 创建一篇新文章

最终结果发布在`my-site/public`目录中，将其整体上传到网站主机即可。

要选择不同的主题样式，可以在[Hugo网站](https://themes.gohugo.io/)上浏览，找到合适的主题，在R中执行命令自动下载安装：

    R> install_theme("gyorb/hugo-dusk")  # 这里以本站当前使用的`hugo-dusk`为例

更多的选项和定制，建议仔细阅读如下电子书和网站：

* https://bookdown.org/yihui/blogdown/
* https://gohugo.io/documentation/
