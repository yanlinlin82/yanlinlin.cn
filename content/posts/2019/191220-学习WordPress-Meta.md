---
title: 学习WordPress页面头部的Meta信息
date: 2019-12-20T13:09:23+08:00
tags: [ HTML5, WordPress, meta ]
---

## 引言

这个学习需求，来自冯大辉老师在其免费知识星球“[互联网消息](https://wx.zsxq.com/mweb/views/topic/topic.html?group_id=452441454848&d=09166029)”中，对一个年轻小朋友关于工作和成长的问题，给出的回答：“**给别人讲一下页面头部的那些Meta都是干啥的**”。见下图摘录：

<a href="/images/2019/1220/ZSXQ_20191219_232341129.png">
<img src="/images/2019/1220/ZSXQ_20191219_232341129.png" style="text-align:center;width:300px;height:auto">
</a>

于是我悄悄在浏览器中输入了“wordpress.com”网址，然后打开源代码瞄了一眼。果然，我这样的过时程序员，立马就在现代 HTML5 代码面前完全迷失了方向。

虽说我仅仅是刚入门 HTML5 （前些天刚手写了一个[极简网页样式](https://yanlinlin82.github.io/webpage-templates/simple-style/index.html)，将其做成一个hugo theme，并用到本网站上），甚至可以说只是远远瞧见了门的样子，但遇到这样的“挑战”，还是不妨沉下心，顺带着学习一遍，也是好的。

然后，便有了这一篇。

## 概览

首先贴一下wordpress.com整个头部（部分过长内容做了删减，并以“...”表示）：

```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en">
<head profile="http://gmpg.org/xfn/11">
<meta charset="utf-8" />
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-P24PF4B');</script>
<!--
<meta property="fb:page_id" content="6427302910" />
-->
<link rel="dns-prefetch" href="//s.w.org" />
<link rel="dns-prefetch" href="//fonts.googleapis.com" />
<link rel="dns-prefetch" href="//fonts.gstatic.com" />
<link rel="dns-prefetch" href="//www.googletagmanager.com" />
<meta name="google-site-verification" content="7VWES_-rcHBcmaQis9mSYamPfNwE03f4vyTj4pfuAw0" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blog Tool, Publishing Platform, and CMS &mdash; WordPress.org</title>
<meta name="referrer" content="always">
<link href="//s.w.org/wp-includes/css/dashicons.min.css?20181204" rel="stylesheet" type="text/css" />
<link href='//fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,400,300,600&subset=latin,cyrillic-ext,greek-ext,greek,vietnamese,latin-ext,cyrillic' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="//s.w.org/style/wp4.css?82" />
<link rel="shortcut icon" href="//s.w.org/favicon.ico?2" type="image/x-icon" />
<meta name="apple-itunes-app" content="app-id=335703880" />
<link rel="alternate" type="application/rss+xml" title="WordPress Blog RSS" href="http://wordpress.org/news/feed/" />
<style type="text/css"> ... </style>
<link rel="alternate" href="https://af.wordpress.org/" hreflang="af" />
<link rel="alternate" href="https://ak.wordpress.org/" hreflang="ak" />
...
<link rel="alternate" href="https://wordpress.org/" hreflang="en" />
<link rel="alternate" href="https://en-au.wordpress.org/" hreflang="en-au" />
...
<link rel="alternate" href="https://cn.wordpress.org/" hreflang="zh-cn" />
<link rel="alternate" href="https://zh-hk.wordpress.org/" hreflang="zh-hk" />
<link rel="alternate" href="https://tw.wordpress.org/" hreflang="zh-tw" />
<link rel="canonical" href="https://wordpress.org/" />
<meta property="og:type" content="website" />
<meta property="og:title" content="Blog Tool, Publishing Platform, and CMS - WordPress" />
<meta property="og:description" content="Open source software which you can use to easily create a beautiful website, blog, or app." />
<meta name="description" content="Open source software which you can use to easily create a beautiful website, blog, or app." />
<meta property="og:url" content="https://wordpress.org/" />
<meta property="og:site_name" content="WordPress" />
<meta property="og:image" content="https://s.w.org/images/home/screen-themes.png?3" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:creator" content="@WordPress" />
<script type="application/ld+json"> ... </script>
<script type="text/javascript" src="//s.w.org/wp-includes/js/jquery/jquery.js?v=1.11.1"></script>
<script>document.cookie='devicePixelRatio='+((window.devicePixelRatio === undefined) ? 1 : window.devicePixelRatio)+'; path=/';</script>
</head>
```

接下来逐条学习。

## 学习笔记

为方便阅读，我会采取如下格式：先摘取上面的代码，然后根据自己的理解进行讲解，同时配上相应的学习参考链接。

### (1)

```html
<!DOCTYPE html>
```

这是HTML5的标准开头，方便浏览器识别当前文件的格式。

### (2)

```html
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en">
```

整个HTML的最外层标签，这里设置了三个属性：

* `xmlns`：由于html本身是xml格式的特例，这个属性是用于定义相应的名字空间（namespace），从而帮助一个格式校验器（validator）检查是否符合相应的语法规范。这里设置的“`http://www.w3.org/1999/xhtml`”，其实是缺省值。
* `dir`：内容文字方向，这里设置的“ltr”是从左到右，也是缺省值。
* `lang`：内容语言，这里设置的“en”是英文，也是缺省值。

我不知道wordpress为什么要把这些缺省值都显式地写出来，猜测也许是为了兼容性（怕某些浏览器未遵循标准采用的别的取值？）或者性能（避免去判断并查找相应的缺省值）吧。

参考学习链接：

* <https://www.w3schools.com/tags/tag_html.asp>
* <https://www.w3schools.com/tags/ref_standardattributes.asp>
* <https://www.w3schools.com/tags/att_global_dir.asp>
* <https://www.w3schools.com/tags/att_global_lang.asp>

### (3)

```html
<head profile="http://gmpg.org/xfn/11">
```

这是HTML头部的开始，它指定了一个`profile`属性，然而，这个属性竟然是HTML5所不支持的，想来应该是为了兼容过去的HTML标准而给出的。打开该取值的URL，原来是一个关于HTML4 Meta的定义：“XFN 1.1 relationships meta data profile”。

参考学习链接：

* <https://www.w3schools.com/tags/tag_head.asp>

### (4)

```html
<meta charset="utf-8" />
```

这是指定当前页面采用的字符集。也就是说，在这个标签之前，只允许最基础的ansi字符（这个所有字符集所共同兼容的），而从这个标签起，就可以采用所指定的其他字符集了。这里采用了最广泛使用的`utf-8`。

关于这个标签，HTML4和HTML5是有写法差异的：

* HTML 4.01: `<meta http-equiv="content-type" content="text/html; charset=UTF-8">`
* HTML5: `<meta charset="UTF-8">`

这里采用的是HTML5的写法，似乎并没有考虑兼容HTML5以前的情况。而标签末尾采用了“... />”的写法，应该是为了让其更符合XML规范。HTML能够容忍一些标签只写起始标签（`<名称>`）而不写结束标签（`</名称>`），大概是为了减轻文本内容的负担（比如常见的`<br>`和`<img>`，要每次都写结束标签，真的非常繁琐，增加了非必需的字符）。从这个角度而言，HTML又并不完全符合XML规范。

参考学习链接：

* <https://www.w3schools.com/tags/tag_meta.asp>

### (5)

```html
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-P24PF4B');</script>
```

接下来的这几行javascript代码，我就暂时不了解其作用了。不过看其结构，`(function(w,d,s,l,i){...})(window,document,...)`，是定义一个函数的同时，给它套了一层括号，直接对它进行调用。效果与直接执行函数体的代码是一样的，所不同的是，简化了传入参数的写法（比如原来要写`window`的地方，经过传参的方式，只需要写成`w`即可）。从这里倒是可以看出javascript世界里“锱铢必较”的一面。

### (6)

```html
<!--
<meta property="fb:page_id" content="6427302910" />
-->
```

这一行是被注释掉了的标签，和后面的一堆`<meta property="og:...`，看起来都是为了Facebook的某些功能接口（Open Graph）服务的。

参考学习链接：

* <https://stackoverflow.com/questions/22350105/whats-the-difference-between-meta-name-and-meta-property>
* <https://stackoverflow.com/questions/8069095/is-the-meta-fbpage-id-still-alowed-on-a-website>
* <http://help.simplytestable.com/errors/html-validation/there-is-no-attribute-x/there-is-no-attribute-property/>
* <https://en.wikipedia.org/wiki/Facebook_Platform#Open_Graph_protocol>

### (7)

```html
<link rel="dns-prefetch" href="//s.w.org" />
<link rel="dns-prefetch" href="//fonts.googleapis.com" />
<link rel="dns-prefetch" href="//fonts.gstatic.com" />
<link rel="dns-prefetch" href="//www.googletagmanager.com" />
```

这几个行告诉浏览器，对这几个网址提前做DNS的预取，这样，浏览器再往下渲染页面时，需要从这些网址（一般都是跨域名的）获取资源时，就不用再等待DNS解析了。

参考学习链接：

* <https://varvy.com/rel/dns-prefetch.html>
* <https://en.wikipedia.org/wiki/Link_prefetching>
* <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control>

### (8)

```html
<meta name="google-site-verification" content="7VWES_-rcHBcmaQis9mSYamPfNwE03f4vyTj4pfuAw0" />
```

这个是向google认证网站归属的。以便进行google搜索引擎更好地识别当前网站，并提供相应的搜索结果信息给到所属者。

参考学习链接：

* <https://developers.google.com/site-verification/v1/getting_started>
* <https://support.google.com/webmasters/answer/9008080?hl=en>
* <https://support.google.com/webmasters/answer/34592?hl=en>

### (9)

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

这一行几乎是现代响应式网页的必备，用来让网页在不同的移动设备上，根据可视区域的大小自动调节，能有比较好的浏览体验。具体原理，已经有很多文章专门介绍和讨论了，可点击下面的链接进行更详细的学习。

参考学习链接：

* <https://www.cnblogs.com/yelongsan/p/7975580.html>
* <https://www.runoob.com/css/css-rwd-viewport.html>
* <https://zhuanlan.zhihu.com/p/59602253>
* <https://www.cnblogs.com/pigtail/archive/2013/03/15/2961631.html>

### (10)

```html
<title>Blog Tool, Publishing Platform, and CMS &mdash; WordPress.org</title>
```

这一行是整个网页的标题，展示在浏览器窗口的顶部，无需多言。通常是先写名称，再写描述，最后是站点名。

### (11)

```html
<meta name="referrer" content="always">
```

这一行是告诉浏览器，在点击链接时，把请求页面一并发送给服务器。这种做法，有助于页面之间的引用关系的建立，除非涉及隐私保护，否则打开会更好。

参考学习链接：

* <https://www.cnblogs.com/liuxiaopi/p/8084896.html>
* <https://www.jianshu.com/p/412130d58464>
* <https://www.freebuf.com/news/57497.html>

### (12)

```html
<link href="//s.w.org/wp-includes/css/dashicons.min.css?20181204" rel="stylesheet" type="text/css" />
<link href='//fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,400,300,600&subset=latin,cyrillic-ext,greek-ext,greek,vietnamese,latin-ext,cyrillic' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="//s.w.org/style/wp4.css?82" />
```

这三行，分别载入了相应站点的css。

### (13)

```html
<link rel="shortcut icon" href="//s.w.org/favicon.ico?2" type="image/x-icon" />
```

这一行指定网站图标，将显示在浏览器标签页上，帮助读者从视觉上识别一个网页。

### (14)

```html
<meta name="apple-itunes-app" content="app-id=335703880" />
```

将当前页面关联到一个Apple iTunes的APP上。这是一种引流方法，可以把用户导向一个移动端的应用程序上，从而实现一些网页上可能支持不足的功能。

参考学习链接：

* <https://stackoverflow.com/questions/47175306/meta-apple-itunes-app-doesnt-work>
* <http://smartappbanners.com/>

### (15)

```html
<link rel="alternate" type="application/rss+xml" title="WordPress Blog RSS" href="http://wordpress.org/news/feed/" />
```

这是提供RSS订阅的相应链接地址。


### (16)

```html
<style type="text/css"> ... </style>
```

指定网页自己的css样式表

### (17)

```html
<link rel="alternate" href="https://af.wordpress.org/" hreflang="af" />
<link rel="alternate" href="https://ak.wordpress.org/" hreflang="ak" />
...
<link rel="alternate" href="https://wordpress.org/" hreflang="en" />
<link rel="alternate" href="https://en-au.wordpress.org/" hreflang="en-au" />
...
<link rel="alternate" href="https://cn.wordpress.org/" hreflang="zh-cn" />
<link rel="alternate" href="https://zh-hk.wordpress.org/" hreflang="zh-hk" />
<link rel="alternate" href="https://tw.wordpress.org/" hreflang="zh-tw" />
```

这是帮助搜索引擎识别相应的地区和语言，从而定位到不同的网址。

参考学习链接：

* <https://en.wikipedia.org/wiki/Hreflang>
* <https://moz.com/learn/seo/hreflang-tag>
* <https://support.google.com/webmasters/answer/189077?hl=en>

### (18)

```html
<link rel="canonical" href="https://wordpress.org/" />
```

这是帮助搜索引擎识别出哪些页面是重复的，将其导向到一个最终的统一链接上。

参考学习链接：

* <https://en.wikipedia.org/wiki/Canonical_link_element>
* <https://yoast.com/rel-canonical/>

### (19)

```html
<meta property="og:type" content="website" />
<meta property="og:title" content="Blog Tool, Publishing Platform, and CMS - WordPress" />
<meta property="og:description" content="Open source software which you can use to easily create a beautiful website, blog, or app." />
```

如前所述，这几行用于Open Graph的信息声明。

### (20)

```html
<meta name="description" content="Open source software which you can use to easily create a beautiful website, blog, or app." />
```

对网站内容进行描述。

### (21)

```html
<meta property="og:url" content="https://wordpress.org/" />
<meta property="og:site_name" content="WordPress" />
<meta property="og:image" content="https://s.w.org/images/home/screen-themes.png?3" />
```

依然是面向Open Graph的信息声明。

### (22)

```html
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:creator" content="@WordPress" />
```

这两行用于声明twitter的信息。

### (23)

```html
<script type="application/ld+json"> ... </script>
<script type="text/javascript" src="//s.w.org/wp-includes/js/jquery/jquery.js?v=1.11.1"></script>
<script>document.cookie='devicePixelRatio='+((window.devicePixelRatio === undefined) ? 1 : window.devicePixelRatio)+'; path=/';</script>
```

载入并运行其他脚本，此处忽略，不做深入学习。

### (24)

```html
</head>
```

页面头部结束。

## 小结

WordPress作为一个被广泛使用的开源博客平台，拥有广大的客户基础。其客户的博客，不管写作目的是什么，最终形式上都是各种内容的输出。这些内容需要被传播、被聚合、被索引，相应的搜索引擎优化（SEO，Search Engine Optimization）技术，也就提供了诸多用武之地。而且随着各类社交平台和APP的兴起，相应的HTML5技术的发展，WordPress自然也会在其头部定义上，对应地下足功夫。

虽然上面这套代码，未必是优化得最好的，我的解读也未必都正确（只是自己作为初学者的一点点理解），但不失为一个学习的起点。
