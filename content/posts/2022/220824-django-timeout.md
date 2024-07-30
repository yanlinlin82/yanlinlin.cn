---
title: 解决Django Timeout问题
date: 2022-08-24T06:44:00+08:00
categories: [ 编程 ]
---

昨天把网站服务器的Ubuntu系统做了大版本升级（升级到22.04.1 LTS），结果导致基于Django开发的[PaperHub](https://paper-hub.cn/)出现卡死。

检查Apache日志，发现如下报错：

```
[Wed Aug 24 04:51:35.847564 2022] [wsgi:error] [pid 4046:tid 139995902613056] [client 195.246.120.35:49245] Truncated or oversized response headers received from daemon process 'paperhub': /home/yanll/paper-hub.cn/paperhub/wsgi.py, referer: https://paper-hub.cn/xiangma/all
[Wed Aug 24 04:51:35.847912 2022] [wsgi:error] [pid 4046:tid 139995911005760] [client 195.246.120.35:57568] Truncated or oversized response headers received from daemon process 'paperhub': /home/yanll/paper-hub.cn/paperhub/wsgi.py, referer: https://paper-hub.cn/xiangma/all
[Wed Aug 24 05:26:08.978739 2022] [wsgi:error] [pid 5333:tid 139996095796800] [remote 101.67.29.167:59153] 2022-05-07 03:31:00+00:00
[Wed Aug 24 05:31:09.122031 2022] [wsgi:error] [pid 4046:tid 139995885827648] (70007)The timeout specified has expired: [client 101.67.29.167:59153] mod_wsgi (pid=4046): Failed to proxy response from daemon.
[Wed Aug 24 06:15:42.106236 2022] [wsgi:error] [pid 4046:tid 139995742438976] (70007)The timeout specified has expired: [client 66.249.79.155:57011] mod_wsgi (pid=4046): Failed to proxy response from daemon.
```

经各种检查和尝试，最后在Apache配置中增加如下一行语句，问题得到解决：

```
WSGIApplicationGroup %{GLOBAL}
```

---

参考链接：

* <https://stackoverflow.com/questions/57002411/django-with-apache-and-mod-wsgi-timeout-error>
* <https://blog.csdn.net/a71468293a/article/details/106997982>
